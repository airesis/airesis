require "sunspot/queue/sidekiq/index_job"
require "sunspot/queue/sidekiq/removal_job"

module Sunspot::Queue::Sidekiq
  class Backend

    # Job needs to include Sidekiq::Worker
    def enqueue(job, klass, id)
      job.perform_async(klass.to_s, id)
    end

    def index(klass, id)
      enqueue(index_job, klass, id)
    end

    def remove(klass, id)
      enqueue(removal_job, klass, id)
    end

    private

    def index_job
      ::Sunspot::Queue::Sidekiq::IndexJob
    end

    def removal_job
      ::Sunspot::Queue::Sidekiq::RemovalJob
    end
  end
end
