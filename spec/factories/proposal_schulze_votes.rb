FactoryGirl.define do
  factory :proposal_schulze_vote do
    proposal { create(:proposal) }
    preferences do
      proposal.solutions.pluck(:id).join(',')
    end
    count 1

    factory :proposal_schulze_vote_by_id do
      preferences do
        proposal.solutions.order(:id).pluck(:id).join(';')
      end
    end
  end
end
