FactoryGirl.define do
  factory :province do
    association :region
    country { region.country }
    description { Faker::Lorem.word }
  end
end
