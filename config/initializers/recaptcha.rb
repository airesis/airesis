Recaptcha.configure do |config|
  config.public_key  = ENV['RECAPTCHA_PUBLIC']
  config.private_key = ENV['RECAPTCHA_PRIVATE']
  config.api_version = 'v2'
end
