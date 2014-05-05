class ProposalWatch < ActiveRecord::Base
  belongs_to :users, class_name: 'User', foreign_key: :user_id
  belongs_to :proposals, class_name: 'Proposal', foreign_key: :proposal_id
end
