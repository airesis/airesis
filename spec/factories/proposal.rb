FactoryGirl.define do
  factory :proposal do

    factory :public_proposal do
      proposal_category_id ProposalCategory::NO_CATEGORY
      title { Faker::Lorem.sentence }
      tags_list ['tag1', 'tag2', 'tag3'].join(',')
      association :quorum
    end

    factory :group_proposal do
      proposal_category_id ProposalCategory::NO_CATEGORY
      title Faker::Lorem.sentence
      tags_list ['tag1', 'tag2', 'tag3'].join(',')
      association :quorum
      association :group_proposals
      visible_outside true
    end

    after(:create) do
      Proposal.reindex
    end
  end
end