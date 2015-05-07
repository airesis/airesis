require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe ProposalPresentation, type: :model, emails: true do

  it "when new authors for a proposal are available sends correctly an email to all participants to the proposal" do
    user1 = create(:user)
    proposal = create(:public_proposal, current_user_id: user1.id)
    participants = []
    5.times do
      user = create(:user)
      participants << user
    end

    create(:proposal_comment, proposal: proposal, user: participants[0])
    create(:proposal_comment, proposal: proposal, user: participants[1])
    create(:proposal_comment, proposal: proposal, user: participants[2])
    create(:proposal_comment, proposal: proposal, user: user1)
    create(:negative_ranking, proposal: proposal, user: participants[3])
    create(:negative_ranking, proposal: proposal, user: participants[4])
    create(:negative_ranking, proposal: proposal, user: user1)

    user2 = create(:user)
    proposal.proposal_presentations.build(user: user2, acceptor: user1)
    proposal.save!

    expect(NotificationProposalPresentationCreate.jobs.size).to eq 1
    NotificationProposalPresentationCreate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 6
    Sidekiq::Extensions::DelayedMailer.drain
    delivery_to_user2 = ActionMailer::Base.deliveries.first
    last_deliveries = ActionMailer::Base.deliveries.last(5)

    expect(last_deliveries.map{|e| e.to[0]}).to match_array participants.map(&:email)
    expect(Alert.last(5).map(&:user)).to match_array participants
    expect(Alert.last.notification_type.id).to eq NotificationType::NEW_AUTHORS

    expect(delivery_to_user2.to[0]).to eq user2.email
    expect(Alert.first.user).to eq user2
    expect(Alert.first.notification_type.id).to eq NotificationType::AUTHOR_ACCEPTED
  end
end
