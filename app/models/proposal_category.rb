class ProposalCategory < ActiveRecord::Base
  translates :description
  has_many :proposals, :class_name => 'Proposal'
end
