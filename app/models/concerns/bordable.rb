module Concerns
  module Bordable
    extend ActiveSupport::Concern

    def solr_search_field
      "#{self.class.name.underscore}_id".to_sym
    end
  end
end
