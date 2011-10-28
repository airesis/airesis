class ProposalVote < ActiveRecord::Base
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
end
