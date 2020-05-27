require 'rails_helper'

RSpec.describe Event do
  let(:user) { create(:user) }
  let(:events) { create_list(:meeting_event, 3, user: user) }

  it 'can be built' do
    expect(create(:vote_event)).to be_valid
    expect(create(:meeting_event)).to be_valid
  end

  context 'time left rendering' do
    let(:now) { Time.zone.now }
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
    before do
      events
    end

    context 'in_territory' do
      it 'works' do
        expect(described_class.in_territory(Municipality.last.country).count).to eq 1
      end
    end

    context 'visible' do
      it 'works' do
        expect(described_class.visible.count).to eq 0
      end
    end

    context 'not visible' do
      it 'works' do
        expect(described_class.not_visible.count).to eq 3
      end
    end

    context 'votation' do
      it 'works' do
        expect(described_class.votation.count).to eq 0
      end
    end

    context 'after_time' do
      it 'works' do
        expect(described_class.after_time.count).to eq 3
      end
    end

    context 'vote_period' do
      it 'works' do
        expect(described_class.vote_period.count).to eq 0
      end
    end
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(1.megabyte) }
    it { is_expected.to validate_presence_of(:starttime) }
    it { is_expected.to validate_presence_of(:endtime) }
    it { is_expected.to belong_to(:event_type) }
    it { is_expected.to belong_to(:user) }
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
