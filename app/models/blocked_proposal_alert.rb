class BlockedProposalAlert < ApplicationRecord
  validates :user_id, uniqueness: { scope: :proposal_id, message: 'Notifiche proposta già bloccate' }

  belongs_to :user
  belongs_to :proposal
end
