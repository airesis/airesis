DemocracyOnline3::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true
  
  
  
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => 'democracyonline.heroku.com' }
  
  

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

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
  PROP_VOTES_TO_PROMOTE=5
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


require 'tlsmail'    
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,  
  :address            => 'smtp.gmail.com',
  :port               => 587,
  :tls                  => true,
  :domain             => 'gmail.com', #you can also use google.com
  :authentication     => :plain,
  :user_name          => 'coorasse@gmail.com',
  :password           => 'dakslqtqaydueqim'
}

# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  config.omniauth :facebook, "242345195791486", "effb2e9b6fb07ce738452c8b3c1a0f57",                   
                      {:scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
end