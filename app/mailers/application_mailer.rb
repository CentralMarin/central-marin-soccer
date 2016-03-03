class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.google_email_from
end
