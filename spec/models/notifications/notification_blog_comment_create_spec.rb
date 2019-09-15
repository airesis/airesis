require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationBlogCommentCreate, type: :model, emails: true, notifications: true do
  before do
    load_database
  end

  let!(:event_class) { described_class }
  let!(:notification_type) { NotificationType.find_by(name: 'new_blog_comment') }
  let!(:expected_alerts) { 1 }

  let!(:user) { create(:user) }
  let!(:blog) { create(:blog, user: user) }
  let!(:blog_post) { create(:blog_post, blog: blog, user: user) }

  def trigger_event
    create(:blog_comment, blog_post: blog_post)
  end

  cumulable_event_process_spec
end
