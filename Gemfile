source 'http://rubygems.org'

ruby File.read(File.join(__dir__, '.ruby-version'))

gem 'rails', '~> 6.0.0'

gem 'sprockets', '< 4.0'
gem 'pg'
gem 'rails_admin'
gem 'bootsnap'
gem 'coffee-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'foundation-rails', '~> 5.0'
gem 'premailer-rails'
gem 'uri-js-rails'
gem 'mustache'
gem 'mustache-js-rails'
gem 'slim-rails'
gem 'daemons'
gem 'rack-cors', require: 'rack/cors'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'paperclip'
gem 'aws-sdk-s3'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'devise'
gem 'devise_traceable', git: 'https://github.com/coorasse/devise_traceable'
gem 'simple_token_authentication'
gem 'koala'
gem 'sinatra', require: false
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'cancancan'
gem 'sitemap_generator'
gem 'geocoder'
gem 'vote-schulze', git: 'https://github.com/coorasse/schulze-vote', ref: '0f47cbb'
gem 'rails_autolink'
gem 'nickname_generator'
gem 'el_finder'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'globalize'
gem 'sanitize'
gem 'webpacker'
gem 'wicked_pdf'
gem 'httparty'
gem 'icalendar'
gem 'private_pub'
gem 'rotp'
gem 'ckeditor'
gem 'timezone', git: 'https://github.com/coorasse/timezone'
gem 'friendly_id'
gem 'gemoji'
gem 'kaminari'
gem 'redcarpet'
gem 'select2-rails'
gem 'simple_form'
# TODO: in version 2.0 support for AR is extracted (https://github.com/geekq/workflow#state-persistence-with-activerecord)
gem 'workflow', '~> 1.2'
gem 'mailman', require: false
gem 'email_reply_parser'
gem 'paper_trail'
gem 'figaro'
gem 'faker'
gem 'sshkit'
gem 'cookies_eu'
gem 'font-awesome-rails'
gem 'truncate_html'
gem 'puma'
gem 'pg_search'
gem 'airesis_i18n', git: 'https://github.com/airesis/airesis_i18n'

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
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'timecop'
end

group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'test-unit'
  gem 'byebug'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'email_spec'
  gem 'ruby-prof'
  gem 'rspec-retry'
  gem 'simplecov', require: false
end

group :development do
  gem 'crowdin-api'
  gem 'rubyzip'
end

group :production do
  gem 'lograge'
  gem 'rails_12factor'
  gem 'appsignal'
end

group :doc do
  gem 'sdoc', require: false
end
