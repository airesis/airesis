require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationProposalUpdate, type: :model, emails: true, notifications: true, seeds: true do
  let!(:event_class) { NotificationProposalUpdate }
  let!(:notification_type) { NotificationType.find_by(name: 'text_update') }
  let!(:expected_alerts) { 3 }

  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }
  let!(:proposal) { create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)]) }
  let!(:participants) do
    expected_alerts.times.map do
      userb = create(:user)
      create_participation(userb, group)
      create(:proposal_comment, proposal: proposal, user: userb)
      userb
    end
  end

  def trigger_event
    proposal.current_user_id = user.id
    content = Faker::Lorem.paragraph
    section = proposal.sections.first
    paragraph = section.paragraphs.first
    update_proposal_params = { sections_attributes:
                                { '0' => { id: section.id, paragraphs_attributes:
                                  { '0' => { id: paragraph.id, content: content, content_dirty: content } } } } }
    proposal.update(update_proposal_params)
  end

  cumulable_event_process_spec
end
