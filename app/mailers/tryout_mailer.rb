class TryoutMailer < ActionMailer::Base
  default from: "tryouts@centralmarinsoccer.com"

  def signup_confirmation(registration_info, tryout_info)

    @tryout_registration = registration_info
    @tryout_info = tryout_info

    mail to: [@tryout_registration[:parent1_email], @tryout_registration[:parent2_email]],
         subject: t('registration.confirmation.subject')
  end
end
