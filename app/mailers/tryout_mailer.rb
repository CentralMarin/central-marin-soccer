class TryoutMailer < ActionMailer::Base
  default from: Rails.application.secrets.google_email_from
  helper TryoutRegistrationsHelper

  def signup_confirmation(registration_info, tryout_info)

    @tryout_registration = registration_info
    @tryout = tryout_info

    mail to: [@tryout_registration[:parent1_email], @tryout_registration[:parent2_email]],
         from: Rails.application.secrets.google_email_from,
         subject: t('registration.confirmation.subject')
  end
end
