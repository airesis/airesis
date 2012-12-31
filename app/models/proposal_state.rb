class ProposalState < ActiveRecord::Base
  has_many :proposals, :class_name => 'Proposal'

  VALUTATION=1
  WAIT_DATE=2
  WAIT=3
  VOTING=4
  REJECTED=5
  ACCEPTED=6
  REVISION=7
end
