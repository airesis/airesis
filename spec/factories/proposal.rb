FactoryGirl.define do
  factory :proposal do
    factory :public_proposal do
      proposal_category_id ProposalCategory::NO_CATEGORY
      title Faker::Lorem.sentence
      tags_list ['tag1', 'tag2', 'tag3'].join(',')
    end

    factory :group_proposal do

    end
  end
end