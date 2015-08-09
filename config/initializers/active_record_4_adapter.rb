module CanCan
  module ModelAdapters
    class ActiveRecord4Adapter
      private

      def build_relation(*where_conditions)
        relation = @model_class.where(*where_conditions)
        relation = relation.joins(joins) if joins.present?
        relation
      end
    end
  end
end
