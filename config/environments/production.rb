Airesis::Application.configure do
  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.i18n.fallbacks = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  config.action_mailer.perform_deliveries = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false
  config.assets.digest = true

  # Generate digests for assets URLs

  config.assets.version = '1.0'

  config.force_ssl = (ENV['FORCE_SSL'].try(:downcase) == 'true')

  # config.logger = Logger.new(Rails.root.join('log', Rails.env + '.log'), 50, 100.megabytes)
  config.log_level = :info
  config.lograge.enabled = true

  config.active_record.raise_in_transactional_callbacks = true
end

Airesis::Application.default_url_options = Airesis::Application.config.action_mailer.default_url_options
