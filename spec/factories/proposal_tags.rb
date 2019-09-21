FactoryBot.define do
  factory :proposal_tag do
    association :proposal
    association :tag
  end
end
