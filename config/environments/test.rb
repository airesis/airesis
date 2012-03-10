DemocracyOnline3::Application.configure do
  

end





DemocracyOnline3::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true
  
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"
    # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false


  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false
  
  

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # Allow pass debug_assets=true as a query parameter to load pages with unpackaged assets
  config.assets.allow_debugging = true
 
  
    #indirizzo del sito
  SITE="http://localhost:3000"
  #numero massimo di commenti per pagina
  COMMENTS_PER_PAGE=5
  #numero massimo di proposte per pagina
  PROPOSALS_PER_PAGE=10
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
  LIMIT_COMMENTS=false
  
  
end

# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  config.omniauth :facebook, "221145254619152", "79039dd7230f1f1c4d2d0544eca98597", 
                      {:scope => 'email', :client_options => {:ssl => {:verify => false, :ca_path => '/etc/ssl/certs'}}}                   
end
