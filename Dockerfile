FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential pdftk
RUN mkdir /myapp

# Set Rails to run in production
ENV RAILS_ENV production

WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake RAILS_ENV=production DATABASE_PWD=foo SECRET_TOKEN=pickasecuretoken assets:precompile

# Add ckeditor files
RUN bundle exec rake
# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["/myapp/public"]

# The default command that gets ran will be to start the Unicorn server.
CMD bundle exec unicorn -c config/unicorn.rb
