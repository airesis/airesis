FactoryGirl.define do
  factory :proposal do
    proposal_category_id ProposalCategory::NO_CATEGORY
    title { Faker::Lorem.sentence }
    tags_list ['tag1', 'tag2', 'tag3'].join(',')
    votation { { later: 'true' } }
    quorum { BestQuorum.visible.first }
    current_user_id { create(:user).id }
    factory :public_proposal do
    end

    factory :group_proposal do
      visible_outside true
      transient do
        groups []
      end

      after(:build) do |proposal, evaluator|
        evaluator.groups.each do |group|
          proposal.group_proposals << GroupProposal.new(group: group)
        end
      end
    end

    after(:build) do |proposal|
      proposal.build_sections
    end

    after(:create) do
      Sunspot.commit
    end
  end
end
