require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationProposalRankingCreate, type: :model, emails: true, notifications: true, seeds: true do

  context 'when the proposal receives a new evaluation during debate phase' do
    let(:user) { create(:user) }
    let(:proposal) { create(:public_proposal, current_user_id: user.id) }
    let(:participants) { create_list(:user, 3) }

    context 'when the author has notifications active' do
      before(:each) do
        user.blocked_alerts.find_by(notification_type_id: NotificationType::NEW_VALUTATION_MINE).destroy
        participants.each do |participant|
          create(:positive_ranking, proposal: proposal, user: participant)
        end
      end

      it 'receives the alerts' do
        expect(described_class.jobs.size).to eq 3
        described_class.drain
        AlertsWorker.drain
        EmailsWorker.drain

        deliveries = ActionMailer::Base.deliveries.last 3

        receivers = [user, user, user]

        emails = deliveries.map { |m| m.to[0] }
        receiver_emails = receivers.map(&:email)
        expect(emails).to match_array receiver_emails

        expect(Alert.unscoped.count).to eq 3
        expect(Alert.last(3).map { |a| a.user }).to match_array receivers
        expect(Alert.last(3).map { |a| a.notification_type.id }).to match_array [NotificationType::NEW_VALUTATION_MINE,
                                                                                 NotificationType::NEW_VALUTATION_MINE,
                                                                                 NotificationType::NEW_VALUTATION_MINE]
      end
    end
  end
end
