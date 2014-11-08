FactoryGirl.define do
  factory :meeting do
    association :event
    association :place, factory: :place
  end
end
