
  ################################
  ##
  ## Spanish Configuration
  ##
  ################################
  server {
    server_name www.es.centralmarinsoccer.com;
    rewrite ^ $scheme://es.centralmarinsoccer.com$request_uri permanent;
  # permanent sends a 301 redirect whereas redirect sends a 302 temporary redirect
  # $scheme uses http or https accordingly
  }

  server {
    listen 80;
    server_name es.centralmarinsoccer.com;
    root /webapps/centralmarinsoccer/current/public;

    location @passenger {
      passenger_enabled on;
      rails_env production;
    }

    # Set expires max on static file types
    location ~* ^.+\.(css|js|jpg|jpeg|gif|png|ico|gz|svg|svgz|ttf|otf|woff|eot|mp4|ogg|ogv|webm)$ {
      expires max;
      root /webapps/centralmarinsoccer/current/public;
      access_log off;
    }

    # opt-in to the future
    add_header "X-UA-Compatible" "IE=Edge,chrome=1";
  }

  ################################
  ##
  ## English Configuration - Development
  ##
  ################################
  server {
    server_name www.centralmarinsoccer.com;
    rewrite ^ $scheme://centralmarinsoccer.com$request_uri permanent;
  # permanent sends a 301 redirect whereas redirect sends a 302 temporary redirect
  # $scheme uses http or https accordingly
  }

  server {
    listen 80 default;
    server_name centralmarinsoccer.localhost;
    root /home/app/centralmarinsoccer_website/public;

    location = / {
      try_files /cache/en/index.html @passenger;
    }

    location / {
      try_files /cache/en$uri.html @passenger;
    }

    location @passenger {
      passenger_enabled on;
      rails_env development;
    }

    # Set expires max on static file types
    location ~* ^.+\.(css|js|jpg|jpeg|gif|png|ico|gz|svg|svgz|ttf|otf|woff|eot|mp4|ogg|ogv|webm)$ {
      expires max;
      root /home/app/centralmarinsoccer_website/public;
      access_log off;
    }

    # opt-in to the future
    add_header "X-UA-Compatible" "IE=Edge,chrome=1";
  }

}
