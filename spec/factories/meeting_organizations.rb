FactoryGirl.define do
  factory :meeting_organization do
    association :group
    association :event
  end
end
