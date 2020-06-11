source 'http://rubygems.org'

ruby File.read(File.join(__dir__, '.ruby-version'))

gem 'rails', '~> 6.0.0'

gem 'aws-sdk-s3'
gem 'bootsnap'
gem 'cancancan'
gem 'ckeditor'
gem 'coffee-rails'
gem 'daemons'
gem 'devise'
gem 'devise_traceable', git: 'https://github.com/coorasse/devise_traceable'
gem 'el_finder'
gem 'foundation-rails', '~> 5.0'
gem 'friendly_id'
gem 'gemoji'
gem 'geocoder'
gem 'globalize'
gem 'httparty'
gem 'icalendar'
gem 'jbuilder'
gem 'jquery-rails'
gem 'kaminari'
gem 'koala'
gem 'mustache'
gem 'mustache-js-rails'
gem 'nickname_generator'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'paperclip'
gem 'pg'
gem 'premailer-rails'
gem 'private_pub'
gem 'rack-cors', require: 'rack/cors'
gem 'rails_admin'
gem 'rails_autolink'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'redcarpet'
gem 'rotp'
gem 'sanitize'
gem 'sass-rails'
gem 'select2-rails'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'simple_form'
gem 'simple_token_authentication'
gem 'sinatra', require: false
gem 'sitemap_generator'
gem 'slim-rails'
gem 'sprockets', '< 4.0'
gem 'timezone', git: 'https://github.com/coorasse/timezone'
gem 'turbolinks'
gem 'uglifier'
gem 'uri-js-rails'
gem 'vote-schulze', git: 'https://github.com/coorasse/schulze-vote', ref: '0f47cbb'
gem 'webpacker'
gem 'wicked_pdf'
# TODO: in version 2.0 support for AR is extracted (https://github.com/geekq/workflow#state-persistence-with-activerecord)
gem 'airesis_i18n', git: 'https://github.com/airesis/airesis_i18n'
gem 'cookies_eu'
gem 'email_reply_parser'
gem 'faker'
gem 'figaro'
gem 'font-awesome-rails'
gem 'mailman', require: false
gem 'paper_trail'
gem 'pg_search'
gem 'puma'
gem 'rack-attack'
gem 'sshkit'
gem 'truncate_html'
gem 'workflow', '~> 1.2'

group :development do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'i18n-tasks'
  gem 'letter_opener'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'thin', require: false # required for private_pub
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'timecop'
end

group :development, :test do
  gem 'byebug'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'test-unit'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'email_spec'
  gem 'rspec-retry'
  gem 'ruby-prof'
  gem 'simplecov', require: false
end

group :development do
  gem 'crowdin-api'
  gem 'rubyzip'
end

group :production do
  gem 'lograge'
  gem 'rails_12factor'
  gem 'sentry-raven'
end

group :doc do
  gem 'sdoc', require: false
end
