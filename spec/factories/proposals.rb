FactoryGirl.define do
  factory :proposal do
    proposal_category_id ProposalCategory::NO_CATEGORY
    title { Faker::Lorem.sentence }
    tags_list %w(tag1 tag2 tag3).join(',')
    votation { { later: 'true' } }
    quorum { BestQuorum.visible.first }
    factory :public_proposal do
    end

    factory :group_proposal do
      association :group_proposals
      visible_outside true
    end

    after(:build) do |proposal|
      proposal.build_sections
    end

    after(:create) do
      Sunspot.commit
    end
  end
end
