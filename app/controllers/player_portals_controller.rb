class PlayerPortalsController < InheritedResources::Base

  layout 'player_portal'

  before_filter except: [:session_new, :session_create] do |controller|
    redirect_to player_portal_login_path unless session[:is_authenticated] == params[:uid]
  end

  PDFTK_PATH = '/usr/local/bin/pdftk'

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
      @message = "Birthday does not match birthday on file. Please try again or contact tryouts@centralmarinsoccer.com to update this information"
      render :session_new
    end

  end

  def session_destroy
    # Clear the session
    reset_session

    # Redirect to the home page
    redirect_to root_path
  end

  # TODO: Show if we have a birth certificate
  # TODO: Show if we have a picture for the player pass
  # TODO: Show current US Club form
  # TODO: Show other documents uploaded from the admin console, e.g. Concusion protocol, positive coaching, etc.
  # TODO: Allow registration of goalie and striker trainings
  def index

    @player_portal = PlayerPortal.find_by(uid: params[:uid])

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

    # Determine volunteer selection and calculate amount due
    fees = calculate_fees(player_portal.club_registration_fee, params[:volunteer].empty?)
    player_portal.volunteer_choice = params[:volunteer]

    # Hookup to the Google Drive
    session = TryoutsController.authorize

    # Create the folder structure
    folder = PlayerPortalsController.usclub_assets_path(session, player_portal)
    unless params['player-image'].empty?
      # Save off the player's image
      filename = PlayerPortalsController.generate_file_name(player_portal, "Image.png")
      image_data = Base64.decode64(params['player-image']['data:image/png;base64,'.length .. -1])
      file = TryoutsController.upload_string(session, image_data, folder, filename)

      # Share with anyone with the link
      file.acl.push({:scope_type => "anyone", :withLink => true, :role => "reader"}, {:sendNotificationEmails => false})

      # TODO: Get the URL for the picture
      player_portal.picture = file.human_url
    end

    unless params['birth-certificate'].nil?
      # Save off birth certificate
      filename = PlayerPortalsController.generate_file_name(player_portal, "Birth Certificate.jpg")
      TryoutsController.upload_string(session, params['birth-certificate'].read, folder, filename)

      player_portal.have_birth_certificate = true
    end

    player_portal.save!
    # TODO: Move strings to localization file and translate

#############
# Force Crash
player_portal.foo.bar

    customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => fees[:total],
        :description => "#{EventGroup::TRYOUT_YEAR} Club Registration Fee",
        :currency    => 'usd'
    )

    player_portal.amount_paid = fees
    player_portal.save!

    flash[:notice] = "Congratulations, #{player_portal.first} has been successfully registered for the #{EventGroup::TRYOUT_YEAR} season!"
    redirect_to player_portal_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to player_portal_registration_path
  end


  def self.generate_club_form(player)

    # tmp file to store pdf
    tmp_form = "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"

    # Fill in PDF Form
    pdftk = PdfForms.new(PDFTK_PATH)

    pdftk.fill_form "#{Rails.root}/lib/pdf_templates/club_form.pdf", tmp_form, player.to_hash, flatten: true

    tmp_form
  end

  def self.generate_file_name(player, suffix)
    "#{player.first} #{player.last} - #{suffix}"
  end

  def self.usclub_assets_path(session, player_portal)
    TryoutsController.create_path(session, 'USClub', player_portal.gender, player_portal.birthday.year.to_s)
  end
  private

    def calculate_fees(registration_fee, volunteer_opt_out)

      goal = registration_fee
      goal += PlayerPortal::VOLUNTEER_OPT_OUT_FEE if volunteer_opt_out

      total = (goal + PlayerPortal::CC_FIXED) / (1-PlayerPortal::CC_PERCENTAGE)
      cc_fees = total - goal

      fees = []
      fees << ['Club Registration', "$#{'%.2f' % registration_fee}"]
      fees << ['Volunteer Opt Out', "$#{'%.2f' % PlayerPortal::VOLUNTEER_OPT_OUT_FEE}"] if volunteer_opt_out
      fees << ['Credit Card Processing', "$#{'%.2f' %cc_fees}"]
      fees << ['Total', "$#{'%.2f' %total}"]

      return {fees: fees, total: (total * 100).round} # convert to cents
    end

    def player_portal_params
      params.require(:player_portal).permit(:id, :birthday, :first, :last)
    end
end

