source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'

gem 'activeadmin', :github => 'gregbell/active_admin'
gem "activeadmin-globalize", :github => 'stefanoverna/activeadmin-globalize', :branch => 'master'
gem 'polyamorous', :github => 'activerecord-hackery/polyamorous'
gem 'ransack',     :github => 'activerecord-hackery/ransack'
gem 'formtastic',  :github => 'justinfrench/formtastic'
gem 'ckeditor', '4.0.11'
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '3.7.0'
gem 'globalize', '4.0.1'
gem 'haml-rails', '0.5.3'
gem 'whenever', '0.9.2', :require => false
gem 'google_drive', '0.3.9'
gem 'parsley-rails', '2.0.0.0'
gem 'premailer-rails', '1.7.0'
gem 'nokogiri', '1.6.1'
gem 'roadie', '2.4.3'
#gem 'delayed_job_active_record'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.5.0'

# Use CoffeeScript for .js.coffee assets and views
#gem 'coffee-rails', '~> 4.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.0.1'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.2.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.0.7'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', :require => false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.2', :require => false, :group => :development
group :development do
  gem 'capistrano-rails',   '~> 1.1.1', :require => false
  gem 'capistrano-bundler', '~> 1.1.2', :require => false
end

group :staging, :production do
  gem 'mysql2'
end

# Use debugger
# gem 'debugger', group: [:development, :test]
