require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationProposalCommentUpdate, type: :model, emails: true, notifications: true, seeds: true do
  it 'when a proposal comment is updated sends correctly an email all people which ranked the comment' do
    user1 = create(:user)
    group = create(:group, current_user_id: user1.id)
    proposal = create(:group_proposal, current_user_id: user1.id, group_proposals: [GroupProposal.new(group: group)])

    participants = []
    5.times do
      user = create(:user)
      participants << user
      create_participation(user, group)
    end

    contribute = create(:proposal_comment, proposal: proposal, user: participants[0])
    create(:positive_comment_ranking, proposal_comment: contribute, user: participants[1])
    create(:negative_comment_ranking, proposal_comment: contribute, user: participants[2])
    create(:neutral_comment_ranking, proposal_comment: contribute, user: participants[3])

    contribute.update!(content: contribute.content)

    # no alerts if the content didn't change
    expect(described_class.jobs.size).to eq 0

    contribute.update!(content: Faker::Lorem.paragraph)

    expect(described_class.jobs.size).to eq 1
    described_class.drain
    AlertsWorker.drain
    EmailsWorker.drain

    deliveries = ActionMailer::Base.deliveries.last(3)

    emails = deliveries.map { |m| m.to[0] }
    receiver_emails = [participants[1], participants[2], participants[3]].map(&:email)
    expect(emails).to match_array(Array.new(3, "discussion+proposal_c_#{proposal.id}@airesis.it"))
    expect(deliveries.map { |m| m.bcc[0] }).to match_array receiver_emails

    expect(Alert.unscoped.count).to eq 3
    expect(Alert.last(3).map(&:user)).to match_array [participants[1], participants[2], participants[3]]
  end
end
