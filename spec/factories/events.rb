FactoryBot.define do
  factory :event do
    association :user
    title { Faker::Company.name }
    starttime { 1.day.from_now }
    endtime { 3.days.from_now }
    all_day { true }
    description { Faker::Lorem.paragraph }

    private { true }

    factory :meeting_event do
      event_type { build(:event_type, :meeting) }
      after(:build) do |event|
        event.meeting = create(:meeting, event: event)
      end
    end

    factory :vote_event do
      event_type { build(:event_type, :votation) }
    end
  end
end
