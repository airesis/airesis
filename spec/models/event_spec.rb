require 'spec_helper'

describe Event do
  let(:user) { create(:user) }
  let(:events) { create_list(:meeting_event, 3, user: user) }

  context 'scope -> in_territory' do
    it 'works' do
      load_municipalities
      events
      expect(Event.in_territory(SysLocale.default.territory).count).to eq 3
    end
  end
end
