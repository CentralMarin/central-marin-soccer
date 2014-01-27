require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

config = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
config.merge! config.fetch(Rails.env, {})
config.each do |key, value|
  ENV[key] = value.to_s unless value.kind_of? Hash
end

module CentralMarinSoccer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += %w(#{config.root}/app/sweepers)

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.i18n.default_locale = :en
    config.i18n.fallbacks = true

    config.secret_key_base = ENV["SECRET_KEY_BASE"]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += %w[header_grad4.png header_grad3.png header_grad2.png main_bg.png logo_inlay.png *.png *.jpg *.jpeg *.gif active_admin.css active_admin.js modernizr-2.6.2.min.js jquery-1.9.0.js jquery-ui.js wowslider.js coach.css coaches.js fields.css fields.js information.css home.js registrations.js jquery.js inline_editing.js information.tournaments.js ckeditor/**/*.js ckeditor/**/*.css dark-hive/jquery-ui-1.10.0.custom.css team.js team.css]

  end
end
