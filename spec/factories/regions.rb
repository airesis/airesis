FactoryGirl.define do
  factory :region do
    association :country
    continent { country.continent }
    description { Faker::Lorem.word }
  end
end
