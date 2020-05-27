FactoryBot.define do
  factory :proposal_comment_ranking do
    association :user
    association :proposal_comment
    factory :positive_comment_ranking do
      ranking_type_id { :positive }
    end
    factory :negative_comment_ranking do
      ranking_type_id { :negative }
    end
    factory :neutral_comment_ranking do
      ranking_type_id { :neutral }
    end
  end
end
