require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationProposalCommentUnintegrate, type: :model, emails: true, notifications: true, seeds: true do
  let!(:notification_type) { NotificationType::UNINTEGRATED_CONTRIBUTE }
  let!(:user) { create(:user) }

  let!(:group) { create(:group, current_user_id: user.id) }

  let!(:proposal) { create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)]) }

  let!(:expected_alerts) { 1 }
  let!(:participants) do
    2.times.map do
      user2 = create(:user)
      create_participation(user2, group)
      user2
    end
  end

  let!(:comment) { create(:proposal_comment, proposal: proposal, user: participants[0]) }

  def create_event
    section = proposal.sections.first
    paragraph = section.paragraphs.first
    content = Faker::Lorem.paragraph
    params = { sections_attributes: {
      '0' => { id: section.id,
               paragraphs_attributes: {
                 '0' => { id: paragraph.id,
                          content: content,
                          content_dirty: content }
               } }
    },
               integrated_contributes_ids_list: comment.id.to_s }

    proposal.current_user_id = user.id
    saved = proposal.update(params)

    proposal.reload
    comment.reload

    expect(comment.integrated).to be_truthy
    comment.unintegrate
    comment.reload
  end

  let!(:trigger_event) { create_event }
  let(:receivers) { [user] }

  it 'unintegrate the contribute' do
    expect(comment.integrated).to be_falsey
  end

  event_process_spec
end
