FROM phusion/passenger-ruby22:latest

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Copy over nginx configuration
ADD nginx/centralmarinsoccer.com /etc/nginx/sites-enabled/centralmarinsoccer.com
ADD nginx/no-default /etc/nginx/sites-enabled/no-default
ADD nginx/mime.types /etc/nginx/mime.types
ADD nginx/nginx.logrotate /etc/logrotate.d/nginx

# Perserve linked container IP address
ADD nginx/mysql-env.conf /etc/nginx/main.d/mysql-env.conf

# Development
# Run Bundle in a cache efficient way
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# Add our site
RUN mkdir /home/app/centralmarinsoccer
ADD . /home/app/centralmarinsoccer
WORKDIR /home/app/centralmarinsoccer
RUN chown -R app:app /home/app/centralmarinsoccer

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
