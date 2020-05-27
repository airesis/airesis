FactoryBot.define do
  factory :proposal_ranking do
    association :user
    association :proposal
    factory :positive_ranking do
      ranking_type_id { :positive }
    end
    factory :negative_ranking do
      ranking_type_id { :negative }
    end
  end
end
