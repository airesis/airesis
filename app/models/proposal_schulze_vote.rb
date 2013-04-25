class ProposalSchulzeVote < ActiveRecord::Base
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id

end
