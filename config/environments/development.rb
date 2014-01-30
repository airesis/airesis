Airesis::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.assets.debug = true

  config.i18n.fallbacks = true
    
  #config.assets.logger = nil
  config.force_ssl = false
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => MAILER_DEFAULT_HOST }
  
  
  config.quiet_assets = true
  
  #indirizzo del sito
  SITE="http://airesisdev.it:3000"
  #numero massimo di commenti per pagina
  COMMENTS_PER_PAGE=5
  #numero massimo di proposte per pagina
  PROPOSALS_PER_PAGE=10

  #topics per page
  TOPICS_PER_PAGE=10
 
  #numero di giorni senza aggiornamenti dopo i quali la proposta viene abolita
  PROP_DAY_STALLED=2

  #limita il numero di commenti
  LIMIT_COMMENTS=false
  COMMENTS_TIME_LIMIT=30.seconds

  #limita il numero di proposte
  LIMIT_PROPOSALS=false
  PROPOSALS_TIME_LIMIT=1.minute

  #limita il numero di gruppi
  LIMIT_GROUPS=true
  GROUPS_TIME_LIMIT=24.hours

  ROTP_DRIFT = 20

  ENCRYPT_WORD="airesis"

  
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

Airesis::Application.default_url_options = Airesis::Application.config.action_mailer.default_url_options