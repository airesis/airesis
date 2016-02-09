require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationEventCreate, type: :model, emails: true, notifications: true, seeds: true do
  let!(:notification_type) { NotificationType::NEW_EVENTS }
  let!(:user) { create(:user) }

  let!(:group) { create(:group, current_user_id: user.id) }

  let!(:expected_alerts) { 3 }
  let!(:group_users) do
    expected_alerts.times.map do
      user2 = create(:user)
      create_participation(user2, group)
      user2
    end
  end

  def create_event
    event = create(:meeting_event, user: user)
    create(:meeting_organization, event: event, group: group)
    create(:meeting, event: event)
  end

  let(:trigger_event) { create_event }
  let(:receivers) { group_users }

  event_process_spec
end
