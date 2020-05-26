class ProposalSupport < ApplicationRecord
  belongs_to :group, class_name: 'Group', foreign_key: :group_id
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id

  validates :proposal_id, uniqueness: { scope: :group_id, message: 'Il gruppo sostiene già questa proposta' }
end
