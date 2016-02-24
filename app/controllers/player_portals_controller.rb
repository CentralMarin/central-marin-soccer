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

  # TODO: Track failed logins - After XXX for a given uid, disable that account
  def index

    @player_portal = PlayerPortal.find_by(uid: params[:uid])

  end

  def club_form

    player = PlayerPortal.find_by(uid: params[:uid])

    # tmp file to store pdf
    tmp_form = "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"

    # Fill in PDF Form
    pdftk = PdfForms.new(PDFTK_PATH)

    pdftk.fill_form "#{Rails.root}/lib/pdf_templates/club_form.pdf", tmp_form, player.to_hash, flatten: true

    # Stream the form the user
    File.open(tmp_form, 'r') do |f|
      send_data f.read.force_encoding('BINARY'), filename: "#{player.first} #{player.last} US Club Form.pdf", disposition: 'inline', type: 'application/pdf'
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

