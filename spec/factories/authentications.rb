FactoryGirl.define do
  factory :authentication do
    association :user
    provider 'facebook'
    token nil
    uid { Faker::Number.number(10) }
  end
end
