FROM ruby:2.1.6

WORKDIR /usr/src/app

EXPOSE 3000

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY .ruby-version /usr/src/app/

RUN ["bundle", "install", "--without=test", "-j8"]



CMD ["bundle", "exec", "rails", "s"]
