class ProposalState < ApplicationRecord
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

  TAB_DEBATE = 'debate'.freeze
  TAB_VOTATION = 'votation'.freeze
  TAB_VOTED = 'voted'.freeze
  TAB_REVISION = 'abandoned'.freeze
end
