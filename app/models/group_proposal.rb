class GroupProposal < ActiveRecord::Base
  belongs_to :group, class_name: 'Group', counter_cache: :proposals_count, inverse_of: :group_proposals
  belongs_to :proposal, class_name: 'Proposal', inverse_of: :group_proposals
end
