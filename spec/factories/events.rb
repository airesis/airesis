FactoryGirl.define do
  factory :event do
    title { Faker::Company.name }
    starttime { 1.day.from_now }
    endtime { 3.days.from_now }
    all_day true
    description { Faker::Lorem.paragraph }
    private true
    association :user
    factory :meeting_event do
      event_type { EventType.meeting }
      association :meeting
    end

    factory :vote_event do
      event_type { EventType.votation }
    end
  end
end
