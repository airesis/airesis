if ENV['SENTRY_PUBLIC_KEY'].present?
  require 'raven'

  Raven.configure(false) do |config|
    config.dsn = "https://#{ENV['SENTRY_PUBLIC_KEY']}:#{ENV['SENTRY_PRIVATE_KEY']}@app.getsentry.com/#{ENV['SENTRY_PORT']}"
  end
end
