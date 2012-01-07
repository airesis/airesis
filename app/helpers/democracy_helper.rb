module DemocracyHelper
  module ActiveRecord
    module Persistence
      def update_columns(attributes)
        raise ActiveRecordError, "can not update on a new record object" unless persisted?
        attributes.each_key {|key| raise ActiveRecordError, "#{key.to_s} is marked as readonly" if self.class.readonly_attributes.include?(key.to_s) }
        attributes.each do |k,v|
          raw_write_attribute(k,v)
        end
        self.class.update_all(attributes, self.class.primary_key => id) == 1
      end
    end
  end
end