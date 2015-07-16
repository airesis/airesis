require 'spec_helper'

describe Event do
  let(:user) { create(:user) }
  let(:events) { create_list(:meeting_event, 3, user: user) }

  context 'scope -> in_territory' do
    it 'works' do
      allow_any_instance_of(User).to receive(:assign_tutorials)
      events
      expect(Event.in_territory(SysLocale.default.territory).count).to eq 3
    end
  end
end
