module CanCan
  module ModelAdapters
    module ActiveRecordAdapter
      def database_records(eager_load = true)
        if override_scope
          @model_class.where(nil).merge(override_scope)
        elsif @model_class.respond_to?(:where) && @model_class.respond_to?(:joins)
          if mergeable_conditions?
            build_relation(eager_load, conditions)
          else
            build_relation(eager_load, *(@rules.map(&:conditions)))
          end
        else
          @model_class.all(conditions: conditions, joins: joins)
        end
      end
    end
  end
end
