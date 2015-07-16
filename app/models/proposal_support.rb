class ProposalSupport < ActiveRecord::Base
  belongs_to :group, class_name: 'Group', foreign_key: :group_id
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id

  validates_uniqueness_of :proposal_id, scope: :group_id, message: 'Il gruppo sostiene già questa proposta'

end
