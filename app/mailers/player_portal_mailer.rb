class PlayerPortalMailer < ApplicationMailer
  def welcome(player_portal)

    @player_portal = player_portal

    # only send email if we have valid email addresses
    if player_portal.email.present? || player_portal.parent1_email.present? || player_portal.parent2_email.present?

      mail to: [player_portal.email, player_portal.parent1_email, player_portal.parent2_email],
           from: Rails.application.secrets.google_email_from,
           subject: "Register now for Central Marin! / Inscribense ahora para Central Marin!"
    end
  end
end
