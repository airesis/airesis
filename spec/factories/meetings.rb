FactoryGirl.define do
  factory :meeting do
    association :place, factory: :place
  end
end
