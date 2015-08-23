FactoryGirl.define do
  factory :country do
    association :continent
    sigla { Faker::Lorem.word }
    description { Faker::Lorem.word }
  end
end
