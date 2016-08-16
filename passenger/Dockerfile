FROM ruby:2.3.1
MAINTAINER rrobinett@centralmarinsoccer.com

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
  build-essential

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./

# If you have problems with timeouts or resolution, use the following line instead
#RUN gem install bundler && bundle install 
RUN gem install bundler && bundle install --jobs 20 --retry 10

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

ENV RAILS_ENV production

ENV PASSENGER_PORT 3000
ENV PASSENGER_ENVIRONMENT production
ENV PASSENGER_MIN_INSTANCES 4
ENV PASSENGER_MAX_POOL_SIZE 4
ENV PASSENGER_FRIENDLY_ERROR_PAGES false
ENV PASSENGER_STICKY_SESSIONS true

# Launch Passenger
CMD ["passenger", "start"]
