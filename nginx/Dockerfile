FROM nginx

# Copy config files
COPY nginx/default.template /etc/nginx/conf.d/default.template

COPY nginx/letsencrypt-acme-challenge.conf /etc/nginx/letsencrypt-acme-challenge.conf
COPY nginx/server_common.conf /etc/nginx/server_common.conf

# Copy static assets
COPY public /usr/share/nginx/html

ENV DOMAIN=centralmarinsoccer.com
EXPOSE 80
EXPOSE 443

CMD /bin/bash -c "envsubst '\$DOMAIN' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"