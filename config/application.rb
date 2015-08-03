require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CentralMarinSoccer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
# config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true


    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

    # Configure the default encoding used in templates for Ruby 2.1.
# config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += %w(header_grad4.png header_grad3.png header_grad2.png main_bg.png logo_inlay.png *.png *.jpg *.jpeg *.gif active_admin.css active_admin.js modernizr-2.6.2.min.js jquery-1.9.0.js jquery-ui.js home.css coach.css coaches.js fields.css fields.js information.css home.js tryouts.js jquery.js inline_editing.js information.tournaments.js ckeditor/*.js ckeditor/*.css ckeditor/**/*.js ckeditor/**/*.css dark-hive/jquery-ui-1.10.0.custom.css team.js team.css tryouts.css active_admin/*.css active_admin/*.js)

  end
end
