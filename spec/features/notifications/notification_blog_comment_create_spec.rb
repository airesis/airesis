require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications for new blog comments to the blog author', type: :feature do



  it "sends correctly an email to author of the blog" do
    user = create(:user)
    blog = create(:blog)
    blog_post = create(:blog_post, blog: blog, user: user)
    user2 = create(:user)
    comment = create(:blog_comment, user: user2, blog_post: blog_post)
    expect(NotificationBlogCommentCreate.jobs.size).to eq 1
    NotificationBlogCommentCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
    Sidekiq::Extensions::DelayedMailer.drain
    last_delivery = ActionMailer::Base.deliveries.last
    expect(last_delivery.to[0]).to eq user.email
    expect(Alert.last.user).to eq user
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_BLOG_COMMENT
  end

  it "join alerts correctly" do
    user = create(:user)
    blog = create(:blog)
    blog_post = create(:blog_post, blog: blog, user: user)
    user2 = create(:user)
    user3 = create(:user)
    comment2 = create(:blog_comment, user: user2, blog_post: blog_post)
    comment3 = create(:blog_comment, user: user3, blog_post: blog_post)
    expect(NotificationBlogCommentCreate.jobs.size).to eq 2
    NotificationBlogCommentCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
    Sidekiq::Extensions::DelayedMailer.drain
    last_delivery = ActionMailer::Base.deliveries.last
    expect(last_delivery.to[0]).to eq user.email
    expect(Alert.last.user).to eq user
    expect(Alert.count).to eq 1
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_BLOG_COMMENT
  end
end
