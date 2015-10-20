if Rails.env.production? && SENTRY_ACTIVE
  require 'raven'
  Raven.configure do |config|
    config.dsn = "https://#{ENV['SENTRY_PUBLIC_KEY']}:#{ENV['SENTRY_PRIVATE_KEY']}@app.getsentry.com/#{ENV['SENTRY_PORT']}"
  end
end
