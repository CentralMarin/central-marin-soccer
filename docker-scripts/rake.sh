#! /bin/sh
docker run --rm -e "RAILS_ENV=development" -u app --link centralmarinsoccer_mysql:centralmarinsoccer_mysql centralmarinsoccer/base rake $1 --trace
