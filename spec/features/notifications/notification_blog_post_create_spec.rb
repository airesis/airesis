require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications for new blog posts to participants in groups in which is published', type: :feature do

  it "sends correctly an email to group participants" do
    user = create(:user)
    blog = create(:blog)
    group = create(:group, current_user_id: user.id)
    blog_post = create(:blog_post, blog: blog, user: user)
    post_publishing = create(:post_publishing, blog_post: blog_post, group: group)

    group_users = []
    10.times do
      user = create(:user)
      create_participation(user, group)
      group_users << user
    end

    expect(NotificationBlogPostCreate.jobs.size).to eq 1
    NotificationBlogPostCreate.drain
    expect(ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.jobs.size).to eq 10
    ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.drain
    last_deliveries = ActionMailer::Base.deliveries.last(10)

    emails = last_deliveries.map { |m| m.to[0] }
    receiver_emails = group_users.map(&:email)

    expect(emails).to match_array receiver_emails
    expect(Alert.last(10).map { |a| a.user }).to match_array group_users
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_POST_GROUP
  end
end
