require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications when a proposal is abandoned', type: :feature do

  it "sends correctly an email to authors and participants" do
    user1 = create(:user)
    group = create(:group, current_user_id: user1.id)
    proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: user1.id, group_proposals: [GroupProposal.new(group: group)])

    user2 = create(:user)
    create_participation(user2, group)
    user3 = create(:user)
    create_participation(user3, group)
    proposal.users << user2
    proposal.users << user3
    participants = []
    5.times do
      user = create(:user)
      participants << user
      create_participation(user, group)
    end

    create(:proposal_comment, proposal: proposal, user: participants[0])
    create(:proposal_comment, proposal: proposal, user: participants[1])
    create(:proposal_comment, proposal: proposal, user: participants[2])
    create(:proposal_comment, proposal: proposal, user: user2)
    create(:proposal_comment, proposal: proposal, user: user3)
    create(:negative_ranking, proposal: proposal, user: participants[3])
    create(:negative_ranking, proposal: proposal, user: participants[4])
    create(:negative_ranking, proposal: proposal, user: user1)
    proposal.save!

    proposal.check_phase(true)  #force the abandon of the proposal

    #it has no valutations so it will be abandoned

    expect(NotificationProposalAbandoned.jobs.size).to eq 1
    NotificationProposalAbandoned.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 8
    Sidekiq::Extensions::DelayedMailer.drain
    first_deliveries = ActionMailer::Base.deliveries.first(3)

    authors = [user1,user2,user3]

    emails = first_deliveries.map { |m| m.to[0] }
    receiver_emails = authors.map(&:email)
    expect(emails).to match_array receiver_emails

    last_deliveries = ActionMailer::Base.deliveries.last(5)
    emails = last_deliveries.map { |m| m.to[0] }
    receiver_emails = participants.map(&:email)
    expect(emails).to match_array receiver_emails

    expect(Alert.count).to eq 8
    expect(Alert.first(3).map { |a| a.user }).to match_array authors
    expect(Alert.first.notification_type.id).to eq NotificationType::CHANGE_STATUS_MINE

    expect(Alert.last(5).map { |a| a.user }).to match_array participants
    expect(Alert.last.notification_type.id).to eq NotificationType::CHANGE_STATUS
  end
end
