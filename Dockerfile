FROM ruby:2.6.1

RUN apt-get update && apt-get install -y openjdk-8-jre && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

EXPOSE 3000
EXPOSE 8983

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY .ruby-version /usr/src/app/

RUN ["bundle", "install", "--without=test", "-j4"]
