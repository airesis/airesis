unless Rails.env.test?
  backend = Sunspot::Queue::Sidekiq::Backend.new
  Sunspot.session = Sunspot::SessionProxy::ThreadLocalSessionProxy.new
  Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)
end
