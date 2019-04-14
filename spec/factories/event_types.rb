FactoryBot.define do
  factory :event_type do
    trait(:meeting) { id { EventType::MEETING } }
    trait(:votation) { id { EventType::VOTATION } }
    initialize_with { EventType.find_or_initialize_by(id: id) }
  end
end
