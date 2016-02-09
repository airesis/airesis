# FIXME: https://github.com/CanCanCommunity/cancancan/pull/171
module CanCan
  module ModelAdapters
    class AbstractAdapter
      def database_records(_eager_load)
        # This should be overridden in a subclass to return records which match @rules
        fail NotImplemented, 'This model adapter does not support fetching records from the database.'
      end
    end
  end
end
