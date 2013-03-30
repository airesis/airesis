require "sunspot/queue/resque"
backend = Sunspot::Queue::Resque::Backend.new
Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend)