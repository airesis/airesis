class ProposalLife < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :quorum

  has_many :old_proposal_presentations, -> { order('id DESC') },
           class_name: 'OldProposalPresentation', inverse_of: :proposal_life, dependent: :destroy
  has_many :users, through: :old_proposal_presentations, class_name: 'User', source: :user
end
