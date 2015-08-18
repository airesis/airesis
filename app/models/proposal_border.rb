class ProposalBorder < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :interest_border
end
