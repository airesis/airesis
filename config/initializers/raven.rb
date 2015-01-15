if ENV['SENTRY_PUBLIC_KEY'].present?
  require 'raven'

  Raven.configure(false) do |config|
    config.dsn = "https://#{ENV['SENTRY_PUBLIC_KEY']}:#{ENV['SENTRY_PRIVATE_KEY']}@#{ENV['SENTRY_HOST']}:#{ENV['SENTRY_PORT']}/#{ENV['SENTRY_PROJECT_ID']}"
  end
end
