class ProposalType < ActiveRecord::Base
  has_many :proposals, :class_name => 'Proposal'

  STANDARD = 1
  POLL = 2
end
