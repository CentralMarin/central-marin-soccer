#! /bin/sh
docker run -e PASSENGER_APP_ENV=development -d -p 80:80 --name centralmarinsoccer_webapp --link centralmarinsoccer_mysql:centralmarinsoccer_mysql centralmarinsoccer/base
docker ps -a
