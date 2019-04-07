FactoryBot.define do
  factory :meeting do
    association :place
    event { build(:event, event_type: build(:event_type, :meeting)) }
  end
end
