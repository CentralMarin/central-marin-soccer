class PlayerPortalMailer < ApplicationMailer
  def welcome(player_portal)

    @player_portal = player_portal

    mail to: 'ryan@robinett.org',
         from: Rails.application.secrets.google_email_from,
         subject: "Register now for Central Marin! / Inscribense ahora para Central Marin!"
  end
end
