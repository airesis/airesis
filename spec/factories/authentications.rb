FactoryBot.define do
  factory :authentication do
    association :user
    provider { 'facebook' }
    token { nil }
    uid { Faker::Number.number(digits: 10) }
  end
end
