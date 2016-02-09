class ProposalState < ActiveRecord::Base
  has_many :proposals

  VALUTATION = 1
  # waiting for the user to choose the date
  WAIT_DATE = 2
  # date choosen. waiting for start
  WAIT = 3
  VOTING = 4
  REJECTED = 5
  ACCEPTED = 6
  REVISION = 7
  ABANDONED = 8

  TAB_DEBATE = 'debate'
  TAB_VOTATION = 'votation'
  TAB_VOTED = 'voted'
  TAB_REVISION = 'abandoned'
end
