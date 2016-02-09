class BlockedProposalAlert < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :proposal_id, message: 'Notifiche proposta già bloccate'

  belongs_to :user
  belongs_to :proposal
end
