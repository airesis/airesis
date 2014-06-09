if defined?(CanCan)
  class Object
    def metaclass
      class << self; self; end
    end
  end

  module CanCan
    module ModelAdapters
      class ActiveRecordAdapter < AbstractAdapter
        @@friendly_support = {}

        def self.find(model_class, id)
          @@friendly_support[model_class]||=model_class.metaclass.ancestors.include?(FriendlyId)
          puts "model_class = #{model_class} == #{@@friendly_support[model_class]}"
          @@friendly_support[model_class] == true ? model_class.friendly.find(id) : model_class.find(id)
        end
      end
    end
  end
end