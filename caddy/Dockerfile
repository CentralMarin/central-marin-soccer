FROM alpine:3.4
MAINTAINER Ryan Robinett <rrobinett@centralmarinsoccer.com>

LABEL caddy_version="0.9.0" architecture="amd64"

RUN apk add --update openssh-client tar curl

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

EXPOSE 80 443

VOLUME /srv
WORKDIR /srv

ADD caddy/Caddyfile /etc/Caddyfile
ADD caddy/Caddyfile.localhost /etc/Caddyfile.localhost

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "-email", "rrobinett@centralmarinsoccer.com"]
