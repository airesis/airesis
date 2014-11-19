FactoryGirl.define do
  factory :proposal_comment do
    content { Faker::Lorem.paragraph }
    association :user
    association :proposal
  end
end
