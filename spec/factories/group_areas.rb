FactoryBot.define do
  factory :group_area do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    default_role_name { Faker::Name.prefix }
    association :group
  end
end
