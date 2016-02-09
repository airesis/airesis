class ProposalVotationType < ActiveRecord::Base
  has_many :proposals, class_name: 'Proposal'

  STANDARD = 1
  PREFERENCE = 2
  SCHULZE = 3
end
