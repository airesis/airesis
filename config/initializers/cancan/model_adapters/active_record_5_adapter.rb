# FIXME: https://github.com/CanCanCommunity/cancancan/pull/171
module CanCan
  module ModelAdapters
    class ActiveRecord5Adapter
      private

      def build_relation(eager_load = true, *where_conditions)
        relation = @model_class.where(*where_conditions)
        if joins.present?
          relation = if eager_load
                       relation.includes(joins).references(joins)
                     else
                       relation.left_joins(joins).distinct
                     end
        end
        relation
      end
    end
  end
end
