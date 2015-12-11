require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationProposalAbandoned, type: :model, emails: true, notifications: true, seeds: true do
  it 'when is abandoned sends correctly an email to authors and participants' do
    user = create(:user)
    group = create(:group, current_user_id: user.id)
    proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)])
    participants = []
    2.times do
      userb = create(:user)
      participants << userb
      create_participation(userb, group)
    end

    create(:proposal_comment, proposal: proposal, user: participants[0])
    create(:negative_ranking, proposal: proposal, user: participants[1])
    proposal.save!

    proposal.check_phase(true)  # force the abandon of the proposal

    expect(described_class.jobs.size).to eq 1
    described_class.drain

    expect(AlertJob.count).to eq 3
    expect(AlertsWorker.jobs.size).to eq 3
    AlertsWorker.drain
    expect(EmailJob.count).to eq 3
    expect(EmailsWorker.jobs.size).to eq 3
    EmailsWorker.drain

    first_delivery = ActionMailer::Base.deliveries.first

    expect(first_delivery.to[0]).to eq user.email

    last_deliveries = ActionMailer::Base.deliveries.last(2)
    emails = last_deliveries.map { |m| m.to[0] }
    receiver_emails = participants.map(&:email)
    expect(emails).to match_array receiver_emails

    expect(Alert.unscoped.count).to eq 3
    expect(Alert.first.user).to eq user
    expect(Alert.first.notification_type.id).to eq NotificationType::CHANGE_STATUS_MINE

    expect(Alert.last(2).map(&:user)).to match_array participants
    expect(Alert.last.notification_type.id).to eq NotificationType::CHANGE_STATUS
  end
end
