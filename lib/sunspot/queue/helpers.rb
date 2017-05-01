require "sunspot/queue/session_proxy"

module Sunspot::Queue
  module Helpers
    def without_proxy
      proxy = nil

      # Pop off the queueing proxy for the block if it's in place so we don't
      # requeue the same job multiple times.
      if Sunspot.session.is_a?(SessionProxy)
        proxy = Sunspot.session
        Sunspot.session = proxy.session
      end

      yield
    ensure
      Sunspot.session = proxy if proxy
    end

    def constantize(klass)
      names = klass.to_s.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  end
end
