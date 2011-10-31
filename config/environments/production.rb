DemocracyOnline3::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  config.action_mailer.default_url_options = { :host => 'http://democracyonline.heroku.com' }
  #config.assets.initialize_on_precompile = false

  #indirizzo del sito
  SITE="http://democracyonline.heroku.com"
  #numero massimo di commenti per pagina
  COMMENTS_PER_PAGE=5
  #percentuale da raggiungere perchè la proposta sia promossa
  PROP_RANKING_TO_PROMOTE=70
  #percentuale sotto la quale la proposta viene abolita
  PROP_RANKING_TO_DEGRADE=20
  #numero di giorni senza aggiornamenti dopo i quali la proposta viene abolita
  PROP_DAY_STALLED=2
  #numero di voti necessari affinchè la proposta possa essere promossa
  PROP_VOTES_TO_PROMOTE=3
  PROP_VALUT=1
  PROP_WAIT_DATE=2
  PROP_WAIT=3
  PROP_VOTING=4
  PROP_RESP=5
  PROP_ACCEPT=6
  ORDER_BY_DATE="2"
  ORDER_BY_RANK="3"
  ORDER_BY_VOTES="4"
  
   #limita il numero di commenti
  LIMIT_COMMENTS=true
end
