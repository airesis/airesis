source 'http://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'rails', '~> 4.2.0'

gem 'turnout'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'sprockets', '2.12.4' # FIXME: https://github.com/rails/sprockets/issues/59

gem 'foundation-rails'

gem 'pg'

gem 'rails_admin'

# content indexing

gem 'sunspot_rails'
gem 'sunspot-queue', github: 'gaffneyc/sunspot-queue'
gem 'sunspot-rails-http-basic-auth', github: 'jwachira/sunspot-rails-http-basic-auth'

gem 'capistrano'
gem 'capistrano-bundler'
gem 'capistrano-rails'
gem 'rvm1-capistrano3', require: false
gem 'premailer-rails'

gem 'uri-js-rails'


gem 'rack-mini-profiler', require: false

# login and sessions
gem 'devise'
gem 'devise_traceable', github: 'coorasse/devise_traceable'
gem 'simple_token_authentication'

gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-meetup'
gem 'omniauth-linkedin'
gem 'omniauth-tecnologiedemocratiche', github: 'TecnologieDemocratiche/omniauth-tecnologiedemocratiche'

# json apis
gem 'rack-cors', :require => 'rack/cors'
gem 'jbuilder'

gem 'aws-sdk', '< 2.0'
gem 'paperclip'

# frontend libraries
gem 'mustache'
gem 'mustache-js-rails'
gem 'slim-rails'
gem 'sanitize'
gem 'sitemap_generator'
gem 'jquery-rails'
gem 'turbolinks'
gem 'friendly_id'
gem 'simple_form'
gem 'gemoji'
gem 'workflow'
gem 'select2-rails'
gem 'redcarpet'
gem 'kaminari'
gem 'cookies_eu', github: 'coorasse/cookies_eu'
gem 'font-awesome-rails'
gem 'truncate_html'

gem 'koala'

gem 'sinatra', require: false

gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidetiq'

gem 'cancancan'

gem 'geocoder'

gem 'vote-schulze', github: 'coorasse/vote-schulze'

gem 'rails_autolink'

gem 'nickname_generator'

gem 'el_finder'

gem 'recaptcha', require: 'recaptcha/rails'

gem 'globalize'

gem 'wicked_pdf'
gem 'httparty'
gem 'icalendar'
gem 'private_pub'
gem 'rotp'
gem 'ckeditor'
gem 'timezone', github: 'coorasse/timezone'
gem 'mailman', require: false
gem 'email_reply_parser'
gem 'paper_trail'
gem 'figaro'
gem 'faker'
gem 'sshkit'
gem 'activerecord-session_store'

group :development do
  gem 'sunspot_solr'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'capistrano-sidekiq'
  gem 'capistrano-passenger'
  gem 'i18n-tasks'
  gem 'rubocop'
  gem 'bullet'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'awesome_print'
  gem 'letter_opener'
  gem 'foreman'
  gem 'thin', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'spring'
  gem 'sunspot_test'
  gem 'timecop'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'ruby-prof'
  gem 'test-unit'
  gem 'simplecov', require: false
  gem 'email_spec'
end

group :development do
  gem 'crowdin-api'
  gem 'rubyzip'
end

group :production do
  gem 'therubyracer'
  gem 'newrelic_rpm'
  gem 'sentry-raven', github: 'getsentry/raven-ruby'
end

group :doc do
  gem 'sdoc', require: false
end
