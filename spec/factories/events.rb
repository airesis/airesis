FactoryGirl.define do
  factory :event do
    title { Faker::Company.name }
    starttime 1.day.from_now
    endtime 3.days.from_now
    all_day true
    description { Faker::Lorem.paragraph }
    private true
    association :user
    factory :meeting_event do
      event_type_id { EventType::INCONTRO }
    end

    factory :vote_event do
      event_type_id { EventType::VOTAZIONE }
    end
  end
end
