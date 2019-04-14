FactoryBot.define do
  factory :user_sensitive do
    association :user
    name { Faker::Name.name }
    surname { Faker::Name.last_name }
    tax_code { Faker::Code.ean }
  end
end
