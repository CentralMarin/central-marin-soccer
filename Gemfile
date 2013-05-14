source 'http://rubygems.org'

gem 'rake', '>= 10.0.0'
gem 'rails', '>= 3.2.12'
#gem 'jquery-rails'
#gem 'jquery-ui-rails'

gem 'activeadmin', '>= 0.5.1'
gem 'meta_search', '>= 1.1.0.pre'
gem 'paper_trail'
gem 'ckeditor', '~>4.0.2'
gem 'carrierwave'
gem 'mini_magick'
gem 'globalize3', '~>0.3.0'
gem 'haml-rails', '~> 0.3.5'
gem 'cancan'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~>3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '~> 1.3.0'
end


group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-nc'
  gem 'factory_girl_rails'
  gem 'annotate', '>=2.5.0'
  gem 'sqlite3'
end

group :development, :test, :staging do
  gem 'faker' # want to use faker in all environments except production
end

group :staging, :production do
  gem 'mysql2'
end

group :test do
  gem 'spork', '~> 0.9.2'
  gem 'capybara', '~>2.1.0'
  gem 'guard-spork'
  gem 'rb-fsevent'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'selenium-webdriver'
end

gem 'libv8', '~> 3.11.8'
gem 'therubyracer', :require => 'v8'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
#gem 'ruby-debug19', :require => 'ruby-debug'

