FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install -y build-essential
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
CMD ["rails","server","-b","0.0.0.0"]