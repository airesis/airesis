require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe Proposal, type: :model, emails: true do

  it 'when is updated sends correctly an email to authors and participants' do
    user = create(:user)
    group = create(:group, current_user_id: user.id)
    proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)])

    participants = []
    3.times do
      userb = create(:user)
      participants << userb
      create_participation(userb, group)
    end

    create(:proposal_comment, proposal: proposal, user: participants[0])
    create(:proposal_comment, proposal: proposal, user: participants[1])
    create(:proposal_comment, proposal: proposal, user: participants[2])

    proposal.current_user_id = user.id

    content = Faker::Lorem.paragraph
    section = proposal.sections.first
    paragraph = section.paragraphs.first

    update_proposal_params = {sections_attributes:
                                {'0' => {id: section.id, paragraphs_attributes:
                                  {'0' => {id: paragraph.id, content: content, content_dirty: content}}}}}
    proposal.update(update_proposal_params)


    expect(NotificationProposalUpdate.jobs.size).to eq 1
    expect(proposal.proposal_jobs.count).to eq 1
    NotificationProposalUpdate.drain
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 3
    Sidekiq::Extensions::DelayedMailer.drain
    first_deliveries = ActionMailer::Base.deliveries.first(3)

    last_deliveries = ActionMailer::Base.deliveries.last(3)
    emails = last_deliveries.map { |m| m.to[0] }
    receiver_emails = participants.map(&:email)
    expect(emails).to match_array receiver_emails

    expect(Alert.count).to eq 3
    expect(Alert.last(3).map { |a| a.user }).to match_array participants
    expect(Alert.last.notification_type.id).to eq NotificationType::TEXT_UPDATE
  end
end
