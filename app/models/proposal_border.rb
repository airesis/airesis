class ProposalBorder < ActiveRecord::Base
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id
  belongs_to :interest_border, class_name: 'InterestBorder', foreign_key: :interest_border_id
end
