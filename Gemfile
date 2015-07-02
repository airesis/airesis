source 'http://rubygems.org'

ruby '2.2.0'

gem 'rails', '~> 4.2'

gem 'therubyracer', platforms: :ruby

gem 'maktoub' #newsletter

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

# not the official repossitory. waiting for update to 5.4.7
gem 'foundation-rails', github: 'johnantoni/foundation-rails', branch: 'foundation-5.4.7'

gem 'pg'

gem 'sunspot_rails', github: 'coorasse/sunspot', tag: 'v2.1.1-threadsafe'
gem 'sunspot-queue'

gem 'capistrano', '~> 3.2.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1'
gem 'rvm1-capistrano3', require: false
gem 'premailer-rails'

gem 'uri-js-rails'

gem 'mustache'
gem 'mustache-js-rails'

group :development do
  gem 'sunspot_solr'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'capistrano-sidekiq'
  gem 'capistrano-passenger'
  gem 'i18n-tasks', '~> 0.7.7'
  gem 'rubocop'
  gem 'rack-mini-profiler', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'database_cleaner', '1.3.0' #issue 317
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'spring'
  gem 'sunspot_test'
end

gem 'crowdin-api', group: [:development, :staging]
gem 'rubyzip', group: [:development, :staging]

group :doc do
  gem 'sdoc', require: false
end

group :staging, :production do
  gem 'newrelic_rpm'
end

gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-meetup'
gem 'omniauth-linkedin'
gem 'omniauth-tecnologiedemocratiche', github: 'TecnologieDemocratiche/omniauth-tecnologiedemocratiche'

gem 'paperclip'

gem 'aws-sdk', '< 2.0'

gem 'jquery-rails'

gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'nprogress-rails'

gem 'jbuilder', '~> 2.0'

gem 'devise'

gem 'devise_traceable', github: 'coorasse/devise_traceable'

gem 'koala', '~> 1.8.0rc1'

gem 'xmpp4r_facebook'

gem 'sinatra', '>= 1.3.0', require: nil

gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidetiq'

gem 'cancancan'

gem 'foreigner'

gem 'sitemap_generator'

gem 'geocoder'

gem 'vote-schulze', github: 'coorasse/vote-schulze'

gem 'rails_autolink'

gem 'nickname_generator'

gem 'el_finder'

gem 'recaptcha', require: 'recaptcha/rails'

gem 'bullet', group: :development
gem 'thin'
gem 'ruby-prof', group: :test
gem 'test-unit', group: :test

gem 'globalize'

gem 'sanitize'

gem 'wicked_pdf'

gem 'httparty'

gem 'icalendar'

gem 'private_pub'

gem 'rotp'

gem 'ckeditor'

gem 'timezone', github: 'coorasse/timezone'

gem 'friendly_id'
gem 'simple_form'
gem 'gemoji'
gem 'workflow'
gem 'select2-rails'
gem 'redcarpet'
gem 'kaminari'

gem 'mailman', require: false

gem 'email_reply_parser'

gem 'paper_trail', '~> 3.0.0'

gem 'client_side_validations', github: 'DavyJonesLocker/client_side_validations'

gem 'client_side_validations-simple_form', github: 'DavyJonesLocker/client_side_validations-simple_form'

gem 'figaro'

gem 'faker'

gem 'sshkit', '1.3.0'

gem 'font-awesome-rails'

gem 'truncate_html'

gem 'sunspot-rails-http-basic-auth', github: 'jwachira/sunspot-rails-http-basic-auth'

gem 'activerecord-session_store'

gem 'sentry-raven', github: 'getsentry/raven-ruby', group: [:staging, :production]
