require "sunspot/queue/helpers"

module Sunspot::Queue::Sidekiq
  class RemovalJob
    include ::Sunspot::Queue::Helpers
    include ::Sidekiq::Worker

    sidekiq_options queue: 'sunspot'

    def perform(klass, id)
      without_proxy do
        ::Sunspot.remove_by_id!(klass, id)
      end
    end
  end
end
