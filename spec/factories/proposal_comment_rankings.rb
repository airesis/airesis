FactoryBot.define do
  factory :proposal_comment_ranking do
    association :user
    association :proposal_comment
    factory :positive_comment_ranking do
      ranking_type_id { RankingType::POSITIVE }
    end
    factory :negative_comment_ranking do
      ranking_type_id { RankingType::NEGATIVE }
    end
    factory :neutral_comment_ranking do
      ranking_type_id { RankingType::NEUTRAL }
    end
  end
end
