Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false
  config.log_level = :debug

  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.consider_all_requests_local = true
  config.action_mailer.raise_delivery_errors = false
  config.action_controller.perform_caching = false
  config.action_controller.enable_fragment_cache_logging = true

  config.active_storage.service = :local

  config.active_record.verbose_query_logs = true

  config.action_mailer.perform_caching = false
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.active_support.deprecation = :log
  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Expands the lines which load the assets
  config.assets.debug = true

  config.assets.quiet = true

  config.force_ssl = false

  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :letter_opener
end

Rails.application.default_url_options = Rails.application.config.action_mailer.default_url_options
