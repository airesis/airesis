require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationParticipationRequestCreate, type: :model, emails: true, notifications: true, seeds: true do
  let!(:event_class) { NotificationParticipationRequestCreate }
  let!(:notification_type) { NotificationType.find_by(name: 'new_participation_request') }
  let!(:expected_alerts) { 3 }

  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }

  let!(:group_users) do
    group.default_role.action_abilitations.create(group_action_id: GroupAction::REQUEST_ACCEPT, group_id: group.id)
    2.times.map do
      userb = create(:user)
      create_participation(userb, group)
      userb
    end
  end

  def trigger_event
    create(:group_participation_request, user: create(:user), group: group)
  end

  cumulable_event_process_spec
end
