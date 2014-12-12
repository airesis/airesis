FROM ruby:2.1.5
MAINTAINER Ilya Kuchaev "kuchaev.iv@gmail.com"

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y libqt4-dev
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk
RUN apt-get install -qq -y nodejs
RUN apt-get install -qq -y nginx
RUN update-rc.d nginx defaults
ADD nginx-sites.conf /etc/nginx/sites-enabled/default

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN bundle install
RUN gem install foreman
