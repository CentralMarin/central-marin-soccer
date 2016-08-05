== README

Configuration -
    Add host entry for local development
    127.0.0.1 centralmarinsoccer.local www.centralmarinsoccer.local es.centralmarinsoccer.local

Production
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



== TODO: Make Payment in PlayerPortal Model a required field and default to 0

3rd Parties Used
Mailgun - Send emails to club
Bing Translate - Automatic English to Spanish translation
Google Docs - Generate Spreadsheets
Stripe - Credit Card Processing

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

Examples:

    Type: Outing
    Header: Night at the Earthquakes
    Description: Come hang out with the club and watch some great soccer
    Image: http://foo.com/image.jpg
    Cost: $20
    Event Details - Optional
    ----
    Type: Outing
    Header: Night at the Earthquakes
    Description: Come hang out with the club and watch some great soccer
    Image: http://foo.com/image.jpg
    Cost: $20

    [N]
        Start: Feb 1, 2016 @ 1:00pm
        Length: 120 minutes
        group:
            Boys: U8, U9, U10
            Girls: U11, U12, U13
        Start: TBD <String would be nice>
        group:
            Boys: U8, U9, U10
            Girls: U11, U12, U13
        Start: <Just date, times to be announced>
        group:
            Boys: U8, U9, U10
            Girls: U11, U12, U13
    ----
    Type: Training
    Start: April 1, 2016 @ 3:30pm
    Length: 90 minutes
    Header: Striker Training
    Description: Get extra training...
    Image: <http> - Optional
    Cost: <optional>
    ----
    Type: Meeting
Event
    Type
    Heading
    Ages and Genders
