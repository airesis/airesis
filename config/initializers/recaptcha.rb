Recaptcha.configure do |config|
  config.site_key = ENV['RECAPTCHA_PUBLIC']
  config.secret_key = ENV['RECAPTCHA_PRIVATE']
end
