Airesis::Application.configure do

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.i18n.fallbacks = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  config.assets.precompile += %w(endless_page.js back_enabled.png landing.css homepage.js redmond/custom.css menu_left.css jquery.js jquery.qtip.js jquery.qtip.css foundation_and_overrides.css ice/index.js html2canvas.js i18n/*.js proposals/show.js)

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.version = '1.0'

  config.force_ssl = false

  config.logger = Logger.new(Rails.root.join("log", Rails.env + ".log"), 50, 100.megabytes)


  config.middleware.use ExceptionNotification::Rack,
                        ignore_exceptions: ['ActiveRecord::RecordNotFound'],
                        ignore_crawlers: %w{Googlebot bingbot},
                        email: {
                            email_prefix: "[Exception] ",
                            sender_address: %{"Airesis Exception" <#{ENV['ERROR_SENDER']}>},
                            exception_recipients: ENV['ERROR_RECEIVER']
                        }

  config.paperclip_defaults = {
      storage: :s3,
      bucket: ENV['AWS_BUCKET'],
      s3_credentials: {
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
  }
end

Airesis::Application.default_url_options = Airesis::Application.config.action_mailer.default_url_options
