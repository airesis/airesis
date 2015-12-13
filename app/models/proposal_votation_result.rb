class ProposalVotationResult < ActiveRecord::Base
  belongs_to :proposal

  validates :proposal, presence: true, uniqueness: true
end
