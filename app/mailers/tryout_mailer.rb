class TryoutMailer < ActionMailer::Base
  default from: "tryouts@centralmarinsoccer.com"

  def signup_confirmation(registration_info, tryout_info)
    @greeting = "Hi"
    @registration = registration_info
    @tryout_info = tryout_info

    mail from: 'tryouts@centralmarinsoccer.com',
         to: [@registration[:parent1_email], @registration[:parent2_email]],
         subject: t('registration.confirmation.subject'),
         bcc: 'tryouts@centralmarinsoccer.com'
  end
end
