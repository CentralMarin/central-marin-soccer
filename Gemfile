source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

gem 'activeadmin', :github => 'gregbell/active_admin'
gem 'activeadmin-globalize', github: 'CentralMarin/activeadmin-globalize'
gem 'ckeditor', '4.1.1'
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '4.2.3'
gem 'globalize', '5.0.1'
gem 'haml-rails', '0.9.0'
gem 'whenever', '0.9.4', :require => false
gem 'google_drive', '1.0.1'
gem 'premailer-rails', '1.8.1'
gem 'nokogiri', '1.6.6.2'
gem 'devise', '3.4.1'
gem 'bing_translator', '4.4.1'
gem 'bitmask_attributes', '1.0.0'
gem 'ranked-model', '0.4.0'
gem 'activeadmin-ranked-model', :github => 'CentralMarin/activeadmin-ranked-model'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '1.3.10'

# Use SCSS for stylesheets
gem 'sass-rails', '5.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.7.1'

# Use CoffeeScript for .js.coffee assets and views
#gem 'coffee-rails', '~> 4.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

# Use jquery as the JavaScript library
gem 'jquery-ui-themes', '0.0.11'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.5.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.2.13'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', :require => false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.7'

# Use Capistrano for deployment
gem 'capistrano-rails',   '1.1.3', :require => false, :group => :development

#gem 'capistrano', '3.2.1', :require => false, :group => :development
#group :development do
#  gem 'capistrano-rails',   '1.1.1', :require => false
#  gem 'capistrano-bundler', '1.1.3', :require => false
#end

group :staging, :production do
  gem 'mysql2', '0.3.18'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development, :test do
  gem 'rspec-rails', '3.2.1'
  gem 'factory_girl_rails', '4.5.0'
  gem 'faker', '1.4.3'
  gem 'capybara', '2.4.4'
  gem 'selenium-webdriver', '2.45.0'
end

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '1.3.6', group: :development
