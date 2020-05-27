require 'active_support/concern'

module Frm
  module Concerns
    module Viewable
      extend ActiveSupport::Concern

      included do
        has_many :views, class_name: 'Frm::View', as: :viewable
      end

      def view_for(user)
        views.find_by(user_id: user.id)
      end

      # Track when users last viewed an element
      def register_view_by(user)
        return unless user

        view = views.find_or_create_by(user_id: user.id)
        view.increment!('count')
        self.class.update_counters id, views_count: 1
        view.past_viewed_at = view.current_viewed_at || Time.zone.now
        view.current_viewed_at = Time.zone.now
        view.save
      end
    end
  end
end
