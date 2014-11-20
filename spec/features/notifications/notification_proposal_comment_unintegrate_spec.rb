require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'notifications when a proposal comment is unintegrated', type: :feature do

  it "sends correctly an email to authors to inform them the contribute has been unintegrated" do
    user1 = create(:user)
    group = create(:group, current_user_id: user1.id)
    proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: user1.id, group_proposals: [GroupProposal.new(group: group)])

    participants = []
    2.times do
      user = create(:user)
      participants << user
      create_participation(user, group)
    end

    comment = create(:proposal_comment, proposal: proposal, user: participants[0])

    section = proposal.sections.first
    paragraph = section.paragraphs.first
    content = Faker::Lorem.paragraph
    params = {sections_attributes: {'0' => {id: section.id, paragraphs_attributes: {'0' => {id: paragraph.id, content: content, content_dirty: content}}}}, integrated_contributes_ids_list: "#{comment.id}"}

    proposal.current_user_id = user1.id
    saved = proposal.update(params)

    proposal.reload
    comment.reload

    expect(comment.integrated).to be_truthy

    comment.unintegrate
    comment.reload

    expect(comment.integrated).to be_falsey

    expect(NotificationProposalCommentUnintegrate.jobs.size).to eq 1
    NotificationProposalCommentUnintegrate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 1
    Sidekiq::Extensions::DelayedMailer.drain
    last_delivery = ActionMailer::Base.deliveries.last
    #
    email = last_delivery.to[0]
    # receiver_emails = [user1,participants[0],participants[1]].map(&:email)
    expect(email).to eq user1.email
    # expect(first_deliveries.map { |m| m.bcc[0] }).to match_array receiver_emails
    #
    #expect(Alert.last.notification_type.id).to eq NotificationType::
    # expect(Alert.count).to eq 3
    # expect(Alert.first(3).map { |a| a.user }).to match_array [user1,participants[0],participants[1]]
  end
end
