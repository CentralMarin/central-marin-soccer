FROM phusion/passenger-ruby22:latest

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]


# Run Bundle in a cache efficient way - Keep it high in the file so other changes don't cause it to run
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Copy over nginx configuration
ADD nginx/centralmarinsoccer.localhost /etc/nginx/sites-enabled/centralmarinsoccer.localhost
ADD nginx/no-default /etc/nginx/sites-enabled/no-default
ADD nginx/mime.types /etc/nginx/mime.types
ADD nginx/nginx.logrotate /etc/logrotate.d/nginx

# Perserve linked container IP address
ADD nginx/mysql-env.conf /etc/nginx/main.d/mysql-env.conf

############################
# Development

# Add our site
RUN mkdir /home/app/centralmarinsoccer
ADD . /home/app/centralmarinsoccer
WORKDIR /home/app/centralmarinsoccer
RUN chown -R app:app /home/app/centralmarinsoccer


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
