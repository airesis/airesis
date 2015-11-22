require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationForumTopicCreate, type: :model, emails: true, notifications: true do
  before(:each) do
    load_database
  end

  let(:notification_type) { NotificationType.find_by(name: NotificationType::NEW_FORUM_TOPIC).id }
  let(:user) do
    user = create(:user)
    user.blocked_alerts.destroy_all
    user
  end
  let(:group) { create(:group, current_user_id: user.id)}
  let(:category) { create(:frm_category, group: group)}
  let(:forum) { create(:frm_forum, category: category)}
  let(:topic) { create(:frm_topic, forum: forum) }

  let(:expected_alerts) { 1 }

  let(:trigger_event) { topic }
  let(:receivers) { [user] }

  event_process_spec
end
