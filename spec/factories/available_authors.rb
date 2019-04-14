FactoryBot.define do
  factory :available_author do
    association :user
    association :proposal
  end
end
