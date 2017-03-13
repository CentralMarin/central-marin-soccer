class PlayerPortalMailer < ApplicationMailer

  def welcome(player_portal)

    @player_portal = player_portal

    # only send email if we have valid email addresses
    if player_portal.email.present? || player_portal.parent1_email.present? || player_portal.parent2_email.present?

      mail to: [player_portal.email, player_portal.parent1_email, player_portal.parent2_email],
           from: ENV['MAILGUN_FROM'],
           subject: "Register now for Central Marin! / Inscribense ahora para Central Marin!"
    end
  end

  # def notify(player_portal, subject_en, body_en, subject_es, body_es)
  #   @player_portal = player_portal
  #   @body_en = body_en
  #   @body_es = body_es
  #
  #   mailer = mail to: [player_portal.email, player_portal.parent1_email, player_portal.parent2_email],
  #        from: Rails.application.secrets.google_info_email_from,
  #        subject: "#{player_portal.first} - #{subject_en} / #{subject_es}" if valid_email?(player_portal)
  #
  #   message_params = { from: Rails.application.secrets.mailgun_from,
  #            to: [player_portal.email, player_portal.parent1_email, player_portal.parent2_email],
  #            subject: "#{player_portal.first} - #{subject_en} / #{subject_es}",
  #            html: mailer.body
  #   }
  #
  #   if @mg_client.nil?
  #     @mg_client = Mailgun::Client.new Rails.application.secrets.mailgun_api_key
  #   end
  #
  #   @mg_client.send_message(Rails.application.secrets.mailgun_domain, message_params)
  # end

  protected

  def valid_email?(player_portal)
    player_portal.email.present? || player_portal.parent1_email.present? || player_portal.parent2_email.present?
  end
end
