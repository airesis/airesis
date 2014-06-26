Recaptcha.configure do |config|
  config.public_key  = ENV['RECAPTCHA_PUBLIC']
  config.private_key = ENV['RECAPTCHA_PRIVATE']
end
