require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationProposalReadyForVote, type: :model, emails: true, notifications: true, seeds: true do
  it 'when a proposal is ready for vote sends correctly an email to all authors' do
    user1 = create(:user)
    proposal = create(:public_proposal, current_user_id: user1.id)
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

    expect(described_class.jobs.size).to eq 1
    described_class.drain
    AlertsWorker.drain
    EmailsWorker.drain

    deliveries = ActionMailer::Base.deliveries.last 3

    receivers = [participants[0], participants[1], user1]

    emails = deliveries.map { |m| m.to[0] }
    receiver_emails = receivers.map(&:email)
    expect(emails).to match_array receiver_emails

    expect(Alert.unscoped.count).to eq 3
    expect(Alert.last(3).map(&:user)).to match_array receivers
    expect(Alert.last(3).map { |a| a.notification_type.id }).to match_array Array.new(3, NotificationType::CHANGE_STATUS_MINE)
  end
end
