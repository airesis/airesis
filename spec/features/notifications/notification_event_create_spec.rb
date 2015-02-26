require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications for new events to participants in groups in which is published', type: :feature do

  it "sends correctly an email to group participants" do
    user = create(:user)
    group = create(:group, current_user_id: user.id)
    group_users = []
    10.times do
      user2 = create(:user)
      create_participation(user2, group)
      group_users << user2
    end

    event = create(:meeting_event, user: user)
    create(:meeting_organization, event: event, group: group)
    create(:meeting, event: event)

    expect(NotificationEventCreate.jobs.size).to eq 1
    NotificationEventCreate.drain
    expect(ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.jobs.size).to eq 10
    ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.drain
    last_deliveries = ActionMailer::Base.deliveries.last(10)

    emails = last_deliveries.map { |m| m.to[0] }
    receiver_emails = group_users.map(&:email)

    expect(emails).to match_array receiver_emails
    expect(Alert.last(10).map { |a| a.user }).to match_array group_users
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_EVENTS
  end
end
