require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications when a proposal comment is created', type: :feature, js: true do

  it "sends correctly an email to authors and participants" do
    user1 = create(:user)
    group = create(:group, current_user_id: user1.id)
    proposal = create(:group_proposal, quorum: BestQuorum.visible.first, current_user_id: user1.id, group_proposals: [GroupProposal.new(group: group)])

    participants = []
    5.times do
      user = create(:user)
      participants << user
      create_participation(user, group)
    end

    create(:positive_ranking, proposal: proposal, user: participants[0])
    create(:negative_ranking, proposal: proposal, user: participants[1])

    create(:proposal_comment, proposal: proposal, user: participants[2])

    expect(NotificationProposalCommentCreate.jobs.size).to eq 1
    NotificationProposalCommentCreate.drain
    expect(ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.jobs.size).to eq 3
    ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.drain
    first_deliveries = ActionMailer::Base.deliveries.first(3)

    emails = first_deliveries.map { |m| m.to[0] }
    receiver_emails = [user1,participants[0],participants[1]].map(&:email)
    expect(emails).to match_array(Array.new(3,"discussion+proposal_c_#{proposal.id}@airesis.it"))
    expect(first_deliveries.map { |m| m.bcc[0] }).to match_array receiver_emails

    expect(Alert.unscoped.count).to eq 3
    expect(Alert.first(3).map { |a| a.user }).to match_array [user1,participants[0],participants[1]]


    login_as participants[0], as: :user
    visit root_path
    expect_notifications
  end
end
