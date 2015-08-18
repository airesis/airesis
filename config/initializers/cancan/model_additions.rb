module CanCan
  module ModelAdditions
    module ClassMethods
      def accessible_by(ability, action = :index, eager_load = true)
        ability.model_adapter(self, action).database_records(eager_load)
      end
    end
  end
end
