class TryoutMailer < ActionMailer::Base

  helper TryoutRegistrationsHelper

  def signup_confirmation(registration_info, tryout_info)

    @tryout_registration = registration_info
    @tryout = tryout_info

    mail to: [@tryout_registration[:email], @tryout_registration[:parent1_email], @tryout_registration[:parent2_email]],
         from: ENV['MAILGUN_FROM'],
         subject: t('registration.confirmation.subject')
  end
end
