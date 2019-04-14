FactoryBot.define do
  factory :participation_role do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    association :group
  end
end
