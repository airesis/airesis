Airesis::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  config.assets.precompile += %w(endless_page.js back_enabled.png landing.css redmond/custom.css menu_left.css jquery.js ice/index.js html2canvas.js jquery.qtip.js jquery.qtip.css i18n/*.js foundation.js foundation_and_overrides.css)


  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.debug = false

  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {:host => 'arengo.org'}
  config.action_mailer.logger = nil

  config.logger = Logger.new(Rails.root.join("log", Rails.env + ".log"))
  config.logger.level = Logger::WARN

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  #indirizzo del sito
  SITE="http://www.arengo.org"
  #numero massimo di commenti per pagina
  COMMENTS_PER_PAGE=5
  #numero massimo di proposte per pagina
  PROPOSALS_PER_PAGE=10
  TOPICS_PER_PAGE=10

  #numero di giorni senza aggiornamenti dopo i quali la proposta viene abolita
  PROP_DAY_STALLED=2

  #limita il numero di commenti
  LIMIT_COMMENTS=true
  COMMENTS_TIME_LIMIT=5.seconds

  #limita il numero di proposte
  LIMIT_PROPOSALS=true
  PROPOSALS_TIME_LIMIT=2.minutes

  #limita il numero di gruppi
  LIMIT_GROUPS=true
  GROUPS_TIME_LIMIT=24.hours

  ROTP_DRIFT = 20

  config.middleware.use ExceptionNotification::Rack,
                        :ignore_exceptions => ['ActiveRecord::RecordNotFound'],
                        :ignore_crawlers => %w{Googlebot bingbot},
                        :email => {
                            :email_prefix => "[Exception] ",
                            :sender_address => %{"Exception Notifier" <exceptions@airesis.it>},
                            :exception_recipients => %w{coorasse+exceptions@gmail.com carlo.mion@airesis.it}
                        }

end

ActionMailer::Base.default :from => "AiresisTest <info@airesis.it>"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address => EMAIL_ADDRESS,
    :port => 587,
    :authentication => :plain,
    :user_name => EMAIL_USERNAME,
    :password => EMAIL_PASSWORD
}

Airesis::Application.default_url_options = Airesis::Application.config.action_mailer.default_url_options
