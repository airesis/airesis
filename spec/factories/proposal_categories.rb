FactoryBot.define do
  factory :proposal_category do
    initialize_with { ProposalCategory.find_or_initialize_by(name: name) }

    trait :no_category do
      name { 'no_category' }
    end
  end
end
