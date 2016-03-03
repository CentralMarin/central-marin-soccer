class PlayerPortalMailer < ApplicationMailer
  def welcome(player_portal)

    @player_portal = player_portal

    mail to: 'ryan@robinett.org',
         from: Rails.application.secrets.google_email_from,
         subject: t('registration.confirmation.subject')
  end
end
