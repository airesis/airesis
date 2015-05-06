require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications when a new proposal is created', type: :feature, emails: true do

  it "sends correctly an email to all people which can view proposals in the group" do
    user1 = create(:user)
    group = create(:group, current_user_id: user1.id)
    participants = []
    5.times do
      user = create(:user)
      participants << user
      create_participation(user, group)
    end
    proposal = create(:group_proposal, current_user_id: participants[1].id, group_proposals: [GroupProposal.new(group: group)])

    expect(NotificationProposalCreate.jobs.size).to eq 1
    NotificationProposalCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 5
    Sidekiq::Extensions::DelayedMailer.drain
    deliveries = ActionMailer::Base.deliveries.last 5

    receivers = [participants[0],participants[2],participants[3],participants[4],user1]

    emails = deliveries.map { |m| m.to[0] }
    receiver_emails = receivers.map(&:email)
    expect(emails).to match_array receiver_emails

    expect(Alert.count).to eq 5
    expect(Alert.last(5).map { |a| a.user }).to match_array receivers
    expect(Alert.last(5).map{|a| a.notification_type.id}).to match_array Array.new(5,NotificationType::NEW_PROPOSALS)
  end

  it "users do not receive notifications for public proposals by default" do
    user1 = create(:user)
    participants = []
    5.times do
      user = create(:user)
    end
    proposal = create(:public_proposal, current_user_id: user1.id)

    expect(NotificationProposalCreate.jobs.size).to eq 1
    NotificationProposalCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 0
    Sidekiq::Extensions::DelayedMailer.drain
    expect(Alert.count).to eq 0
  end

  it "users can receive notifications for public proposals" do
    user1 = create(:user)
    participants = []
    2.times do
      user = create(:user)
      user.blocked_alerts.find_by(notification_type_id: NotificationType::NEW_PUBLIC_PROPOSALS).destroy
    end
    proposal = create(:public_proposal, current_user_id: user1.id)

    expect(NotificationProposalCreate.jobs.size).to eq 1
    NotificationProposalCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 2
    Sidekiq::Extensions::DelayedMailer.drain
    expect(Alert.count).to eq 2
  end
end
