require 'spec_helper'

describe Event do
  let(:user) { create(:user) }
  let(:events) { create_list(:meeting_event, 3, user: user) }


  context 'scopes' do
    before(:each) do
      load_municipalities
      events
    end
    context 'in_territory' do
      it 'works' do
        expect(Event.in_territory(SysLocale.default.territory).count).to eq 3
      end
    end

    context 'visible' do
      it 'works' do
        expect(Event.visible.count).to eq 0
      end
    end

    context 'not visible' do
      it 'works' do
        expect(Event.not_visible.count).to eq 3
      end
    end
  end

  context 'validations' do
    it 'validates presence of title' do
      event = build(:event, title: nil)
      expect_errors_on_model_field(event, :title, 1)
    end

    it 'validates presence of description' do
      event = build(:event, description: nil)
      expect_errors_on_model_field(event, :description, 1)
    end

    it 'validates presence of starttime' do
      event = build(:event, starttime: nil)
      expect_errors_on_model_field(event, :starttime, 1)
    end

    it 'validates presence of endtime' do
      event = build(:event, endtime: nil)
      expect_errors_on_model_field(event, :endtime, 1)
    end

    it 'validates presence of event_type' do
      event = build(:event, event_type: nil)
      expect_errors_on_model_field(event, :event_type, 1)
    end

    it 'validates presence of user' do
      event = build(:event, user: nil)
      expect_errors_on_model_field(event, :user, 1)
    end
  end
end
