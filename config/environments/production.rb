Airesis::Application.configure do

  # config.force_ssl = true
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  config.assets.precompile += %w(endless_page.js back_enabled.png landing.css homepage.js redmond/custom.css menu_left.css jquery.js jquery.qtip.js jquery.qtip.css foundation_and_overrides.css ice/index.js html2canvas.js i18n/*.js)

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.debug = false

  config.active_support.deprecation = :notify

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

# Log the query plan for queries taking more than this (works
# with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.4

  config.logger = Logger.new(Rails.root.join("log", Rails.env + ".log"), 50, 100.megabytes)

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.paperclip_defaults = {
      storage: :s3,
      bucket: ENV['AWS_BUCKET'],
      s3_credentials: {
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
  }
end
