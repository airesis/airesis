# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  config.secret_key = ENV['DEVISE_SECRET_KEY']
  config.mailer_sender = ENV['DEFAULT_FROM']

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 10

  # TODO
  # config.pepper = ENV['DEVISE_PEPPER_KEY']

  config.reconfirmable = true

  config.password_length = 6..128

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  require 'omniauth-facebook'
  config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
                  scope: 'email',
                  client_options: { ssl: { verify: false, ca_path: '/etc/ssl/certs' } },
                  secure_image_url: true

  require 'omniauth-google-oauth2'
  config.omniauth :google_oauth2, ENV['GOOGLE_APP_ID'], ENV['GOOGLE_APP_SECRET'], {}

  require 'omniauth-twitter'
  config.omniauth :twitter, ENV['TWITTER_APP_ID'], ENV['TWITTER_APP_SECRET']

  require 'omniauth-meetup'
  config.omniauth :meetup, ENV['MEETUP_APP_ID'], ENV['MEETUP_APP_SECRET']

  require 'omniauth-linkedin'
  config.omniauth :linkedin, ENV['LINKEDIN_APP_ID'], ENV['LINKEDIN_APP_SECRET']
end
