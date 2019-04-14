Rails.application.configure do
  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.i18n.fallbacks = true

  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

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

  config.log_tags = [:request_id]

  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :notify

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.active_record.raise_in_transactional_callbacks = true
end

Rails.application.default_url_options = Rails.application.config.action_mailer.default_url_options
