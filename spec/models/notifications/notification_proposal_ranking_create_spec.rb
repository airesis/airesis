require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

describe NotificationProposalRankingCreate, type: :model, emails: true, notifications: true, seeds: true do
  context 'when the proposal receives a new evaluation during debate phase' do
    let(:user) { create(:user) }
    let(:proposal) { create(:public_proposal, current_user_id: user.id) }
    let(:participants) { create_list(:user, 3) }

    context 'when the author has notifications active' do
      before do
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

        last_delivery = ActionMailer::Base.deliveries.last

        receiver = user

        email = last_delivery.to[0]
        receiver_email = receiver.email
        expect(email).to eq receiver_email

        expect(Alert.unscoped.count).to eq 1
        expect(Alert.last.user).to eq receiver
        expect(Alert.last.notification_type.id).to eq NotificationType::NEW_VALUTATION_MINE
      end
    end
  end
end
