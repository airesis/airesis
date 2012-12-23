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
  config.assets.compile = false

  config.assets.precompile += %w(endless_page.js back_enabled.png)


  # Generate digests for assets URLs
  config.assets.digest = true
  
  config.assets.debug = false
  
  config.active_support.deprecation = :notify
  
  
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => 'http://www.airesis.it' }
  
  

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
  SITE="http://www.airesis.it"
  #numero massimo di commenti per pagina
  COMMENTS_PER_PAGE=5
  #numero massimo di proposte per pagina
  PROPOSALS_PER_PAGE=10
 
  
  #numero di giorni senza aggiornamenti dopo i quali la proposta viene abolita
  PROP_DAY_STALLED=2
 
   #limita il numero di commenti
  LIMIT_COMMENTS=true
  
  
  config.middleware.use ExceptionNotifier,
    :email_prefix => "[Exception] ",
    :sender_address => %{"Exception Notifier" <coorasse+notifier@gmail.com>},
    :exception_recipients => %w{coorasse+exceptions@gmail.com}

end


require 'tlsmail'    
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

ActionMailer::Base.default :from => "Airesis <info@airesis.it>"
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = false
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,  
  :address            => 'smtp.gmail.com',
  :port               => 587,
  :tls                  => true,
  :domain             => 'gmail.com', #you can also use google.com
  :authentication     => :plain,
  :user_name          => ENV['airesis_prod_smtp_user_name'],
  :password           => ENV['airesis_prod_smtp_password']
}

# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  require "omniauth-facebook"
  config.omniauth :facebook, "242345195791486", ENV['airesis_prod_facebook_key'],                   
                      {:scope => 'email', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  
  require "omniauth-google-oauth2"
  config.omniauth :google_oauth2, "597462824491.apps.googleusercontent.com", ENV['airesis_prod_google_key'], { access_type: "offline", approval_prompt: "" }                    
end
