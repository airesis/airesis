FactoryGirl.define do
  factory :region do
    association :country
    description {Faker::Lorem.word}
  end
end
