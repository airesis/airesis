class OldProposalPresentation < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal_life
end
