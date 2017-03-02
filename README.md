# README

=======
## Configurations
We currently have two different configuration - Development and Production

### Development

Setup

* Install Docker - [Download](https://docs.docker.com/docker-for-mac/)
* Add host entry for local development
> 127.0.0.1 centralmarinsoccer.local www.centralmarinsoccer.local es.centralmarinsoccer.local

* Build and launch the docker containers using docker-compose
> docker-compose build
> docker-compose up

Entrypoints:
* Web Server - http://centralmarinsoccer.local:8080
* Rails Application Server - http://centralmarinsoccer.local:3000
        
### Debugging 
TODO: Talk about how to configure remote ruby debugging and the steps necessary to launch it

## Production

### Deployment
TODO: Need scripts for different scenarios
Look at using quay.io - Doesn't allow provie containers. Still might work. Just means anyone can launch our site....

* Initial Deployment
* Updating Database
* Updating App Container
* Updating Web Container

TODO: Need to understand downtime for each of the scenarios

* Need to create a shared volume for assets between web and app
* Run bundle exec rake assets:precompile RAILS_ENV=production which will compile them to the shared assets volume



# TODO
* Get all teams from teams API
* Associate coaches with teams
* Existing Teams and Team Levels goes away


Docker containers should default to just work in production mode. Any overrides for Development are handled in docker-compose file

What does deployment look like?
    - Need to run a rake assets:precompile and include these in the web Dockercontainer build


Option 2: use a shared volume, and precompile assets as a job

Shared volumes cannot be updated in the build process, but can be updated by a container instance. So we can run our rake task to precompile the assets just before running our app:

docker build -t hello .
docker run -v /apps/hello/assets:/app/public/assets hello rake assets:precompile
docker run --name hello-app hello rackup
docker run --name hello-web -p 80:80 --link hello-app:app -v /apps/hello/assets:/usr/share/nginx/html/assets nginx
This looks like a more robust option, but will require a more complex instrumentation. I'm leaning towards this option, however, since we'll need a separate job for database migrations anyway.







# Future

* Don't allow fields to be nil
* Make Payment in PlayerPortal Model a required field and default to 0
* Allow partial payments / payment plans through the player portal w/ due dates and reminders for each portion of the payment
* Collect team fees through the player portal

3rd Parties Used
Mailgun - Send emails to club
Bing Translate - Automatic English to Spanish translation
Google Docs - Generate Spreadsheets
Stripe - Credit Card Processing

