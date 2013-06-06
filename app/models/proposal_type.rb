class ProposalType < ActiveRecord::Base
  has_many :proposals, :class_name => 'Proposal'

  STANDARD = 'STANDARD'
  POLL = 'POLL'
  RULE_BOOK = 'RULE_BOOK'
  PRESS = 'PRESS'
  EVENT = 'EVENT'
  ESTIMATE = 'ESTIMATE'
  AGENDA = 'AGENDA'
  CANDIDATE = 'CANDIDATE'

  scope :active, where(:active => true)



end
