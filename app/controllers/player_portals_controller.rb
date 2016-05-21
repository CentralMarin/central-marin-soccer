class PlayerPortalsController < InheritedResources::Base

  layout 'player_portal'

  before_filter except: [:session_new, :session_create] do |controller|
    redirect_to player_portal_login_path unless session[:is_authenticated] == params[:uid]
  end

  def session_new

  end

  def session_create

    # Check if this is a valid combination
    player = PlayerPortal.find_by(uid: params[:uid])
    birthday = params[:PlayerPortal][:birthday]

    if !birthday.blank? && player.birthday == Date.parse(birthday)
      session[:is_authenticated] = params[:uid]

      redirect_to player_portal_path
    else
      @failed = true
      render :session_new
    end

  end

  def session_destroy
    # Clear the session
    reset_session

    # Redirect to the home page
    redirect_to root_path
  end

  def index
    @player_portal = PlayerPortal.find_by(uid: params[:uid])
    @events = Event.all
  end

  def events
    player_portal = PlayerPortal.find_by(uid: params[:uid])
    stripe_email = params['stripeEmail']
    stripe_token = params['stripeToken']
    event = Event.find_by(id: params['event'])

    # update the database in a transaction
    PlayerPortal.transaction do

      # Find the events selected
      dates_selected = []
      count = 0
      params.keys.each do |key|
        if key.start_with?('event_detail_')
          dates_selected << EventDetail.find_by(id: key.scan(/\d+$/).first).start.strftime("%m/%d/%Y")
          count += 1
        end
      end

      # Calculate the amount due
      subtotal = event.cost * count
      total = (subtotal + calculate_cc_fees(subtotal)).round(2)

      # Notify stripe about the amount
      charge = Stripe::Charge.create(
          :amount      => (total * 100).to_i,
          :description => event.title,
          :source => stripe_token,
          :currency    => 'usd',
          :metadata => {player_first: player_portal.first, player_last: player_portal.last, player_birthday: player_portal.birthday, md5: player_portal.md5, event_dates: dates_selected.join(', ')},
          :receipt_email => stripe_email,
          :statement_descriptor => event.title[0..20]
      )

      params.keys.each do |key|
        if key.start_with?('event_detail_')
          EventRegistration.create!(event_detail_id: key.scan(/\d+$/).first, player_portal_id: player_portal.id, charge: charge.id, amount: event.cost)
        end
      end
    end

    render json: {}, status: 200

  rescue Stripe::CardError => e
    render json: { :error => e.message }, :status => 402
  end

  def events_refund
    player_portal = PlayerPortal.find_by(uid: params[:uid])
    event_registration = EventRegistration.find_by(id: params[:id])

    PlayerPortal.transaction do
      # Grab the event registration information
      charge = event_registration.charge
      amount = event_registration.amount

      # Remove the mapping for the player
      event_registration.destroy

      # Ask Stripe to refund the cost of the event
      refund = Stripe::Refund.create(charge: charge, amount: amount * 100, reason: :requested_by_customer)
    end

    render json: {}, status: 200

  end

  def club_form
    player = PlayerPortal.find_by(uid: params[:uid])

    # stream down the pdf
    tmp_form = PlayerPortalsController.generate_club_form(player)
    File.open(tmp_form, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), filename: PlayerPortalsController.generate_file_name(player, "- US Club Form.pdf"), disposition: 'inline', type: 'application/pdf'
    end
    File.delete(tmp_form)

  end

  def registration
    @player_portal = PlayerPortal.find_by(uid: params[:uid])

    @fees = {}

    @fees[:volunteer] = calculate_fees(@player_portal.club_registration_fee, false)
    @fees[:volunteer][:id] = 'fees'
    @fees[:opt_out] = calculate_fees(@player_portal.club_registration_fee, true)
    @fees[:opt_out][:id] = 'feesWithOptOut'
  end

  def registration_create
    player_portal = PlayerPortal.find_by(uid: params[:uid])

    # Hookup to the Google Drive
    session = TryoutsController.authorize

    # US Club Form Status
    player_portal.toggle_status(:form, params[:USClub_complete] == '1')

    # Create the folder structure
    folder = PlayerPortalsController.usclub_assets_path(session, player_portal)
    if params['player-image'].present?
      # Save off the player's image
      filename = PlayerPortalsController.generate_file_name(player_portal, "Image.jpg")
      image_data = Base64.decode64(params['player-image']['data:image/jpeg;base64,'.length .. -1])
      file = TryoutsController.upload_string(session, image_data, folder, filename)

      # Share with anyone with the link
      file.acl.push({:scope_type => "anyone", :withLink => true, :role => "reader"}, {:sendNotificationEmails => false})

      # Get the URL for the picture
      player_portal.picture = "https://docs.google.com/uc?id=#{file.id}"
      player_portal.status << :picture
    end

    if params['birth-certificate'].present?
      # Save off birth certificate
      filename = PlayerPortalsController.generate_file_name(player_portal, "Birth Certificate.jpg")
      TryoutsController.upload_string(session, params['birth-certificate'].read, folder, filename)

      player_portal.status << :proof_of_birth
    end

    # Save that we have images in case the credit card gets rejected
    player_portal.save!

    unless player_portal.status?(:paid)
      # Determine volunteer selection and calculate amount due
      volunteer_choice = params[:volunteer].to_sym
      player_portal.status << :volunteer

      fees = calculate_fees(player_portal.club_registration_fee, volunteer_choice == :opt_out)[:total]
      player_portal.volunteer_choice = volunteer_choice

      charge = Stripe::Charge.create(
          :amount      => fees,
          :description => "#{Event::TRYOUT_YEAR} Club Registration Fee",
          :source => params[:stripeToken],
          :currency    => 'usd',
          :metadata => {player_first: player_portal.first, player_last: player_portal.last, player_birthday: player_portal.birthday, volunteer: volunteer_choice, md5: player_portal.md5},
          :receipt_email => params['stripeEmail'],
          :statement_descriptor => 'CM Club Registration'
      )

      player_portal.status << :paid

      player_portal.amount_paid = "$#{'%.2f' % (fees / 100.0)}"

      # Documents read
      player_portal.toggle_status(:docs_reviewed, params[:documents] == '1')

      player_portal.save!
    end

    render json: {}, status: 200

  rescue Stripe::CardError => e
    render json: { :error => e.message }, :status => 402
  end

  def self.generate_club_form(player, filename = "#{SecureRandom.uuid}.pdf", path = '/tmp/pdfs')

    # Make sure the tmp folder exists
    unless Dir.exist?(path)
      Dir.mkdir path
    end

    # tmp file to store pdf
    tmp_form = "#{path}/#{filename}"

    # Fill in PDF Form
    pdftk = PdfForms.new(Rails.configuration.x.pdftk_path)

    pdftk.fill_form "#{Rails.root}/lib/pdf_templates/club_form.pdf", tmp_form, player.to_hash, flatten: true

    tmp_form
  end

  def self.generate_file_name(player, suffix)
    "#{player.first} #{player.last} - #{suffix}"
  end

  def self.usclub_assets_path(session, player_portal)
    club_folder = "USClub#{' - Development' if Rails.env.development?}"
    TryoutsController.create_path(session, club_folder, player_portal.gender, player_portal.birthday.year.to_s)
  end

  private

    def calculate_cc_fees(subtotal)
      (subtotal + PlayerPortal::CC_FIXED) / (1-PlayerPortal::CC_PERCENTAGE) - subtotal
    end

    def calculate_fees(registration_fee, volunteer_opt_out)

      goal = registration_fee
      goal += PlayerPortal::VOLUNTEER_OPT_OUT_FEE if volunteer_opt_out

      cc_fees = calculate_cc_fees(goal)
      total = goal + cc_fees

      fees = []
      fees << [t('player_portal.registration.payment.club'), "$#{'%.2f' % registration_fee}"]
      fees << [t('player_portal.registration.payment.opt_out'), "$#{'%.2f' % PlayerPortal::VOLUNTEER_OPT_OUT_FEE}"] if volunteer_opt_out
      fees << [t('player_portal.registration.payment.cc_fee'), "$#{'%.2f' %cc_fees}"]
      fees << [t('player_portal.registration.payment.total'), "$#{'%.2f' %total}"]

      {fees: fees, total: (total * 100).round} # convert to cents
    end

    def player_portal_params
      params.require(:player_portal).permit(:id, :birthday, :first, :last)
    end
end

