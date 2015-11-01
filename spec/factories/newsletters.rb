FactoryGirl.define do
  factory :newsletter do
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end
end
