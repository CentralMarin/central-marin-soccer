#! /bin/sh
docker run --rm -e PASSENGER_APP_ENV=development -i -t -p 80:80 --name centralmarinsoccer_webapp --link centralmarinsoccer_mysql:centralmarinsoccer_mysql centralmarinsoccer/base bash
