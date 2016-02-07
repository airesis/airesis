require 'spec_helper'

describe Event do
  let(:user) { create(:user) }
  let(:events) { create_list(:meeting_event, 3, user: user) }

  context 'time left rendering' do
    let(:now) { Time.now }
    let(:event) { build(:event, endtime: difference.since(now)) }
    let(:description) do
      Timecop.freeze(now) do
        event.time_left
      end
    end

    context 'precise hours left' do
      let(:difference) { 9.hours }

      it 'display the time left correctly' do
        expect(description).to eq '9 hours'
      end
    end

    context 'precise minutes left' do
      let(:difference) { 12.minutes }

      it 'display the time left correctly' do
        expect(description).to eq '12 minutes'
      end
    end

    context 'precise seconds left' do
      let(:difference) { 50.seconds }

      it 'display the time left correctly' do
        expect(description).to eq '50 seconds'
      end
    end

    context 'minutes and seconds left' do
      let(:difference) { 10.minutes + 50.seconds }

      it 'display the time left correctly' do
        expect(description).to eq '10 minutes'
      end
    end

    context 'hours, minutes and seconds left' do
      let(:difference) { 3.hours + 10.minutes + 50.seconds }

      it 'display the time left correctly' do
        expect(description).to eq '3 hours'
      end
    end

    context 'hours and seconds left' do
      let(:difference) { 2.hours + 30.seconds }

      it 'display the time left correctly' do
        expect(description).to eq '2 hours'
      end
    end

    context 'days left' do
      let(:difference) { 20.days }

      it 'display the time left correctly' do
        expect(description).to eq '20 days'
      end
    end
  end

  context 'scopes' do
    before(:each) do
      events
    end
    context 'in_territory' do
      it 'works' do
        expect(Event.in_territory(Municipality.first.country).count).to eq 1
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

    context 'votation' do
      it 'works' do
        expect(Event.votation.count).to eq 0
      end
    end

    context 'after_time' do
      it 'works' do
        expect(Event.after_time.count).to eq 3
      end
    end

    context 'vote_period' do
      it 'works' do
        expect(Event.vote_period.count).to eq 0
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

  context 'ics format' do
    let(:event) { create(:meeting_event) }

    it 'exports in ics format' do
      ical_event = event.to_ics
      expect(ical_event.dtstart).to eq event.ics_starttime
      expect(ical_event.dtend).to eq event.ics_endtime
    end
  end
end
