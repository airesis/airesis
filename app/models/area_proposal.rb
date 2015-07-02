class AreaProposal < ActiveRecord::Base
  belongs_to :group_area, class_name: 'GroupArea', foreign_key: :group_area_id
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id
end
