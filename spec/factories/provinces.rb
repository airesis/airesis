FactoryBot.define do
  factory :province do
    association :region
    country { region.country }
    continent { country.continent }
    description { Faker::Lorem.word }
  end
end
