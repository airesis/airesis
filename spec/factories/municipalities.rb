FactoryGirl.define do
  factory :municipality do
    association :province
    region { province.region }
    country { region.country }
    description { Faker::Lorem.word }
  end
end
