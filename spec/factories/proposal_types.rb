FactoryBot.define do
  factory :proposal_type do
    initialize_with { ProposalType.find_or_initialize_by(name: name) }
    active { true }

    trait :standard do
      name { 'STANDARD' }
      color { '#C5F6EF' }
    end
  end
end
