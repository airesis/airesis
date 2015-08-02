class AreaProposal < ActiveRecord::Base
  belongs_to :group_area
  belongs_to :proposal
end
