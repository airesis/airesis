require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications when the debate is finished and the proposal is waiting for a date', type: :feature do

  it "sends correctly an email to all authors" do
    user1 = create(:user)
    proposal = create(:public_proposal, quorum: BestQuorum.visible.first, current_user_id: user1.id)
    participants = []
    2.times do
      user = create(:user)
      participants << user
      create(:positive_ranking, proposal: proposal, user: user)
      proposal.proposal_presentations.create(user: user, acceptor: user1)
    end
    proposal.check_phase(true)
    proposal.reload
    expect(proposal.waiting_date?).to be_truthy

    expect(NotificationProposalReadyForVote.jobs.size).to eq 1
    NotificationProposalReadyForVote.drain
    expect(ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.jobs.size).to eq 3
    ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.drain
    deliveries = ActionMailer::Base.deliveries.last 3

    receivers = [participants[0], participants[1], user1]

    emails = deliveries.map { |m| m.to[0] }
    receiver_emails = receivers.map(&:email)
    expect(emails).to match_array receiver_emails

    expect(Alert.unscoped.count).to eq 3
    expect(Alert.last(3).map { |a| a.user }).to match_array receivers
    expect(Alert.last(3).map { |a| a.notification_type.id }).to match_array Array.new(3, NotificationType::CHANGE_STATUS_MINE)
  end
end
