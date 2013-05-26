Airesis::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin


  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

# Log the query plan for queries taking more than this (works
# with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5


  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  
  #config.assets.logger = nil
  config.force_ssl = false
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  
  
  config.quiet_assets = true
  
  #indirizzo del sito
  SITE="http://localhost:3000"
  #numero massimo di commenti per pagina
  COMMENTS_PER_PAGE=5
  #numero massimo di proposte per pagina
  PROPOSALS_PER_PAGE=10
 
  #numero di giorni senza aggiornamenti dopo i quali la proposta viene abolita
  PROP_DAY_STALLED=2

  #limita il numero di commenti
  LIMIT_COMMENTS=false
  COMMENTS_TIME_LIMIT=30.seconds

  #limita il numero di proposte
  LIMIT_PROPOSALS=true
  PROPOSALS_TIME_LIMIT=2.minutes

  #limita il numero di gruppi
  LIMIT_GROUPS=true
  GROUPS_TIME_LIMIT=24.hours


  
  #config.gem 'resque-mongo', :lib => 'resque'

  
end


ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address            => EMAIL_ADDRESS,
    :port               => 587,
    :authentication     => :plain,
    :user_name          => EMAIL_USERNAME,
    :password           => EMAIL_PASSWORD
}

# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  require "omniauth-facebook"
  config.omniauth :facebook, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET,
                      {:scope => 'email', :client_options => {:ssl => {:verify => false, :ca_path => '/etc/ssl/certs'}}}
                      
  require "omniauth-google-oauth2"
  config.omniauth :google_oauth2, GOOGLE_APP_ID, GOOGLE_APP_SECRET, { access_type: "offline", approval_prompt: "" }

  require "omniauth-twitter"
  config.omniauth :twitter,TWITTER_APP_ID, TWITTER_APP_SECRET

  require "omniauth-meetup"
  config.omniauth :meetup,MEETUP_APP_ID, MEETUP_APP_SECRET

  require "omniauth-linkedin"
  config.omniauth :linkedin, LINKEDIN_APP_ID, LINKEDIN_APP_SECRET
end
