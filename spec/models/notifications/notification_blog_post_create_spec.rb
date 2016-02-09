require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationBlogPostCreate, type: :model, emails: true, notifications: true do
  before(:each) do
    load_database
  end

  let(:notification_type) { NotificationType::NEW_POST_GROUP }
  let(:user) { create(:user) }
  let(:blog) { create(:blog) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:blog_post) { create(:blog_post, blog: blog, user: user) }

  let(:expected_alerts) { 3 }

  let!(:group_users) do
    expected_alerts.times.map do
      user = create(:user)
      create_participation(user, group)
      user
    end
  end

  let(:post_publishing) { create(:post_publishing, blog_post: blog_post, group: group) }

  let(:trigger_event) { post_publishing }
  let(:receivers) { group_users }

  event_process_spec
end
