FactoryGirl.define do
  factory :country do
    association :continent
    description { Faker::Lorem.word }
    sigla { Faker::Lorem.characters 3 }
  end
end
