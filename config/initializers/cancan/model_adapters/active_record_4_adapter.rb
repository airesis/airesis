# FIXME: https://github.com/CanCanCommunity/cancancan/pull/171
module CanCan
  module ModelAdapters
    class ActiveRecord4Adapter
      private

      def build_relation(eager_load = true, *where_conditions)
        relation = @model_class.where(*where_conditions)
        if joins.present?
          if eager_load
            relation = relation.includes(joins).references(joins)
          else
            relation = relation.joins(joins).uniq
          end
        end
        relation
      end
    end
  end
end
