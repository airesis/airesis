module Devise
  module Models
    module Blockable
      extend ActiveSupport::Concern
      def active_for_authentication?
        super && !self.blocked
      end
    end
  end
end
