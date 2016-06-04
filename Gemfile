source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

gem 'activeadmin', :git => 'http://github.com/gregbell/active_admin'
gem 'activeadmin-globalize', git: 'http://github.com/CentralMarin/activeadmin-globalize'
gem 'ckeditor', '4.1.6'
gem 'carrierwave', '0.11.2'
gem 'mini_magick', '4.5.1'
gem 'globalize', '5.0.1'
gem 'haml-rails', '0.9.0'
gem 'whenever', '0.9.4', :require => false
gem 'google_drive', '2.0.1'
gem 'premailer-rails', '1.9.2'
gem 'nokogiri', '1.6.7.2'
gem 'devise', '4.1.1'
gem 'bing_translator', '4.6.0'
gem 'bitmask_attributes', '1.0.0'
gem 'ranked-model', '0.4.0'
gem 'activeadmin-ranked-model', :git => 'http://github.com/CentralMarin/activeadmin-ranked-model'
gem 'html_press', '0.8.2'
gem 'pdf-forms', '1.0.0'
gem 'stripe', '1.43.0'
gem 'mailgun-ruby', '1.1.0', require: 'mailgun'
gem 'delayed_job_active_record', '4.1.1'
gem 'daemon-spawn', '0.4.2'

# Use SCSS for stylesheets
gem 'bootstrap-sass', '3.3.6'
gem 'sass-rails', '5.0.4'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.7.2'

# Use CoffeeScript for .js.coffee assets and views
#gem 'coffee-rails', '~> 4.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

# Use jquery as the JavaScript library
gem 'jquery-ui-themes', '0.0.12'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.5.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.5.0'

gem 'axlsx', '2.0.1'
gem 'axlsx_rails', '0.4.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', :require => false
end

# Use Capistrano for deployment
group :development do
  gem 'capistrano-rails',   '1.1.6'
  gem 'capistrano-faster-assets', '1.0.2'
  gem 'capistrano-passenger', '0.2.0'
  gem 'letter_opener_web', '1.3.0'
end

group :development do
  gem 'sqlite3', '1.3.11'
end

group :staging, :production do
  gem 'mysql2', '0.4.4'
end

group :development, :test do
  gem 'i18n-tasks', '~> 0.9.5'
  gem 'rspec-rails', '3.4.2'
  gem 'factory_girl_rails', '4.7.0'
  gem 'faker', '1.6.3'
  gem 'capybara', '2.7.1'
  gem 'selenium-webdriver', '2.53.0'
end

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '1.7.1', group: :development
