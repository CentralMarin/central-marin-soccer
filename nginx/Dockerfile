FROM nginx

# Copy config files
COPY nginx/centralmarinsoccer.com.conf /etc/nginx/conf.d/centralmarinsoccer.com.conf
COPY nginx/letsencrypt-acme-challenge.conf /etc/nginx/letsencrypt-acme-challenge.conf
COPY nginx/server_common.conf /etc/nginx/server_common.conf

# Copy static assets
COPY public /usr/share/nginx/html

EXPOSE 80
EXPOSE 443
