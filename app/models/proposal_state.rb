class ProposalState < ActiveRecord::Base
  has_many :proposals, class_name: 'Proposal'

  VALUTATION=1
  WAIT_DATE=2
  WAIT=3
  VOTING=4
  REJECTED=5
  ACCEPTED=6
  REVISION=7
  ABANDONED=8

  TAB_DEBATE = 1
  TAB_VOTATION = 2
  TAB_VOTED = 3
  TAB_REVISION = 4


  VALUTATION_STATE="1"
  VOTATION_STATE="2"
  ACCEPTED_STATE="3"
  REVISION_STATE="4"
end
