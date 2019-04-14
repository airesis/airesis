FactoryBot.define do
  factory :blog do
    title { Faker::Company.name }
    association :user
  end
end
