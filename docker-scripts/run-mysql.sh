#! /bin/sh
docker run --name centralmarinsoccer_mysql -e MYSQL_ROOT_PASSWORD='root' -e MYSQL_DATABASE=centralmarinsoccer_development -d mysql
docker ps -a
