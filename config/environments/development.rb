Airesis::Application.configure do

  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise an error on page load if there are pending migrations
  #config.active_record.migration_error = :page_load

  config.i18n.fallbacks = true

  # Expands the lines which load the assets
  config.assets.debug = true

  config.force_ssl = false

  config.action_mailer.perform_deliveries = true

  config.active_record.raise_in_transactional_callbacks = true

end

Airesis::Application.default_url_options = Airesis::Application.config.action_mailer.default_url_options
