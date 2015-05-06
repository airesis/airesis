require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications for new participation requests in the group are sent to whoever can accept them', type: :feature, emails: true do

  it "sends correctly the admin" do
    user = create(:user)
    group = create(:group, current_user_id: user.id)

    user2 = create(:user)
    create(:group_participation_request, user: user2, group: group)

    expect(NotificationParticipationRequestCreate.jobs.size).to eq 1
    NotificationParticipationRequestCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
    Sidekiq::Extensions::DelayedMailer.drain
    last_delivery = ActionMailer::Base.deliveries.last

    expect(last_delivery.to[0]).to eq user.email
    expect(Alert.last.user).to eq user
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_PARTICIPATION_REQUEST
  end

  it "sends correctly the email to whoever has the permission to accept his request" do
    user = create(:user)
    group = create(:group, current_user_id: user.id)

    group_users = []
    3.times do
      user2 = create(:user)
      create_participation(user2, group)
      group_users << user2
    end
    group_users << user
    group.default_role.action_abilitations.create(group_action_id: GroupAction::REQUEST_ACCEPT, group_id: group.id)

    requester = create(:user)
    create(:group_participation_request, user: requester, group: group)

    expect(NotificationParticipationRequestCreate.jobs.size).to eq 1
    NotificationParticipationRequestCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 4
    Sidekiq::Extensions::DelayedMailer.drain
    last_deliveries = ActionMailer::Base.deliveries.last 4

    emails = last_deliveries.map { |m| m.to[0] }
    receiver_emails = group_users.map(&:email)

    expect(emails).to match_array receiver_emails
    expect(Alert.last(4).map { |a| a.user }).to match_array group_users
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_PARTICIPATION_REQUEST
  end


  it "joins multiple requests" do
    user = create(:user)
    group = create(:group, current_user_id: user.id)

    group_users = []
    2.times do
      user2 = create(:user)
      create_participation(user2, group)
      group_users << user2
    end
    group_users << user
    group.default_role.action_abilitations.create(group_action_id: GroupAction::REQUEST_ACCEPT, group_id: group.id)

    requester1 = create(:user)
    create(:group_participation_request, user: requester1, group: group)

    NotificationParticipationRequestCreate.drain
    Sidekiq::Extensions::DelayedMailer.drain

    requester2 = create(:user)
    create(:group_participation_request, user: requester2, group: group)

    NotificationParticipationRequestCreate.drain
    Sidekiq::Extensions::DelayedMailer.drain
    expect(ActionMailer::Base.deliveries.size).to be 3

    last_deliveries = ActionMailer::Base.deliveries.last 3
    emails = last_deliveries.map { |m| m.to[0] }
    receiver_emails = group_users.map(&:email)

    expect(emails).to match_array receiver_emails
    expect(Alert.last(3).map { |a| a.user }).to match_array group_users
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_PARTICIPATION_REQUEST
    expect(Alert.count).to be 3
  end
end
