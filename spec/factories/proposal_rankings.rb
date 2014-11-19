FactoryGirl.define do
  factory :proposal_ranking do
    association :user
    association :proposal
    factory :positive_ranking do
      ranking_type_id { RankingType::POSITIVE }
    end
    factory :negative_ranking do
      ranking_type_id { RankingType::NEGATIVE }
    end
  end
end
