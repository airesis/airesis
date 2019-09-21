require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe NotificationAvailableAuthorCreate, type: :model, emails: true, notifications: true do
  before do
    load_database
  end

  let!(:event_class) { described_class }
  let!(:notification_type) { NotificationType.find_by(name: 'available_author') }
  let!(:expected_alerts) { 3 }

  let!(:user) { create(:user) }
  let!(:proposal) { create(:public_proposal, current_user_id: user.id) }
  let!(:authors) do
    2.times.map do
      userb = create(:user)
      proposal.users << userb
      proposal.save
      userb
    end
  end

  def trigger_event
    available_author = create(:available_author, proposal: proposal, user: create(:user))
  end

  cumulable_event_process_spec
end
