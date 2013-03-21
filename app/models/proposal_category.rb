class ProposalCategory < ActiveRecord::Base
  has_many :proposals, :class_name => 'Proposal'
end
