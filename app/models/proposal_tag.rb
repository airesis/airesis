class ProposalTag < ActiveRecord::Base
	#unloadable

	belongs_to :proposal, :class_name => 'Proposal'
	belongs_to :tag, :class_name => 'Tag'
end