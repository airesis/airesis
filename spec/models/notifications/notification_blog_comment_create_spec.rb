require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe BlogComment, type: :model, emails: true do

  let!(:user) {create(:user)}
  let!(:blog) {create(:blog, user: user)}
  let!(:blog_post) {create(:blog_post, blog: blog, user: user)}

  it 'for new blog comments sends correctly an email to author of the blog' do
    create(:blog_comment, blog_post: blog_post)

    expect(NotificationBlogCommentCreate.jobs.size).to eq 1
    NotificationBlogCommentCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
    Sidekiq::Extensions::DelayedMailer.drain

    last_delivery = ActionMailer::Base.deliveries.last
    expect(last_delivery.to[0]).to eq user.email
    expect(Alert.last.user).to eq user
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_BLOG_COMMENT
  end

  it 'join alerts correctly' do
    create_list(:blog_comment, 2, blog_post: blog_post)

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
