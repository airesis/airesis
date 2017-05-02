module Sunspot::Queue
  class SessionProxy
    attr_reader :session
    attr_accessor :backend

    def initialize(session, backend)
      @session = session
      @backend = backend
    end

    def index(*objects)
      objects.flatten!

      if !objects.all?(&:persisted?)
        raise NotPersistedError.new("Cannot index records that have not been saved")
      end

      objects.each do |object|
        @backend.index(object.class.name, object.id)
      end
    end
    alias :index! :index

    def remove(*objects, &block)
      if block
        # Delete by query not supported by queue, so send to server
        session.remove(*objects, &block)
      else
        objects.flatten.each do |object|
          # Remove cannot remove an object from Solr if it doesn't have an id.
          # We're assuming if it doesn't have an id then it hasn't been
          # persisted and can safely be ignored since it shouldn't exist in the
          # search index.
          if object.id
            @backend.remove(object.class.name, object.id)
          end
        end
      end
    end

    def remove!(*objects, &block)
      if block
        # Delete by query not supported by queue, so send to server
        session.remove!(*objects, &block)
      else
        remove(*objects)
      end
    end

    # Enqueues a removal job based on class and id.
    def remove_by_id(klass, id)
      @backend.remove(klass.to_s, id)
    end
    alias :remove_by_id! :remove_by_id

    # The following are all delegated to session
    def new_search(*args, &block)
      session.new_search(*args, &block)
    end

    def search(*args, &block)
      session.search(*args, &block)
    end

    def new_more_like_this(*args, &block)
      session.new_more_like_this(*args, &block)
    end

    def more_like_this(*args, &block)
      session.more_like_this(*args, &block)
    end

    def config
      session.config
    end

    def remove_all(*args)
      session.remove_all(*args)
    end

    def remove_all!(*args)
      session.remove_all(*args)
    end

    # All of the following are are here to match API but don't make sense to be
    # implemented
    def batch
      yield if block_given?
    end

    def commit(*args)
    end

    def commit_if_delete_dirty(*args)
    end

    def commit_if_dirty(*args)
    end

    def delete_dirty?
      false
    end

    def dirty?
      false
    end
  end
end
