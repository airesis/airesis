#unless Rails.env.test?
#  require "sunspot/queue/sidekiq"
#  backend = Sunspot::Queue::Sidekiq::Backend.new
#  # Sunspot.session = Sunspot::SessionProxy::ThreadLocalSessionProxy.new
#  Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)
#end
