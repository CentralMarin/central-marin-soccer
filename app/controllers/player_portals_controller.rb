class PlayerPortalsController < InheritedResources::Base

  def session_new

  end

  def session_create

    # Check if this is a valid combination
    player = PlayerPortal.find_by(uid: params[:uid])
    birthday = params[:PlayerPortal][:birthday]

    if !birthday.blank? && player.birthday == Date.parse(birthday)
      session[:is_authenticated] = true

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

    redirect_to player_portal_login_path unless session[:is_authenticated]

    @player_portal = PlayerPortal.find_by(uid: params[:uid])

    # See if we already have a session
  end

  private

    def player_portal_params
      params.require(:player_portal).permit(:id, :birthday, :first, :last)
    end
end

