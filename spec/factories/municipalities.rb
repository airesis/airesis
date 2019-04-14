FactoryBot.define do
  factory :municipality do
    association :province
    region { province.region }
    country { region.country }
    continent { country.continent }
    description { Faker::Lorem.word }
  end
end
