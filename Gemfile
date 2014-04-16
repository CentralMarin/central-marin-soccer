source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'activeadmin', github: 'gregbell/active_admin'
gem "activeadmin-globalize", github: 'stefanoverna/activeadmin-globalize', branch: 'master'
gem 'ckeditor', '~> 4.0.9'
gem 'carrierwave'
gem 'mini_magick'
gem 'globalize', '~> 4.0.0'
gem 'haml-rails', '~> 0.5.3'
gem 'whenever', :require => false
gem 'rails-observers', '~>0.1.2'
gem 'google_drive'
gem 'parsley-rails'
gem 'premailer-rails'
gem 'nokogiri'
gem 'roadie'
#gem 'delayed_job_active_record'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.4.0'

# Use CoffeeScript for .js.coffee assets and views
#gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.1', require: false, group: :development
group :development do
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
end

group :staging, :production do
  gem 'mysql2'
end

# Use debugger
# gem 'debugger', group: [:development, :test]
