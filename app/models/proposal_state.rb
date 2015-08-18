class ProposalState < ActiveRecord::Base
  has_many :proposals

  VALUTATION=1
  #waiting for the user to choose the date
  WAIT_DATE=2
  #date choosen. waiting for start
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
end
