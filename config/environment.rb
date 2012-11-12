# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CentralMarin::Application.initialize!

# Mailer settings
#ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
        :address => 'mail-02.marin.digitalfoundry.com',
        :enable_starttls_auto => false
}