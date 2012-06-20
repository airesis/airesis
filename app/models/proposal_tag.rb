class ProposalTag < ActiveRecord::Base
	unloadable

	belongs_to :proposal
	belongs_to :tag
end