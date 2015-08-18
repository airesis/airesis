require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

# new contributes on own proposal
describe NotificationProposalCommentCreate, type: :model, emails: true, notifications: true, seeds: true do
  let!(:event_class) { NotificationProposalCommentCreate }
  let!(:notification_type) { NotificationType.find_by(name: 'new_contributes_mine') }
  let!(:expected_alerts) { 1 }

  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }
  let!(:proposal) { create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)]) }

  let!(:participants) do
    1.times.map do
      userb = create(:user)
      create_participation(userb, group)
      create(:positive_ranking, proposal: proposal, user: userb)
      userb
    end
  end

  def trigger_event
    create(:proposal_comment, proposal: proposal, user: participants[0])
  end

  cumulable_event_process_spec

end
