class ProposalRevision < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :user
  has_many :revision_section_histories, dependent: :destroy
  has_many :section_histories, -> { order(:seq) }, through: :revision_section_histories, dependent: :destroy
  has_many :solution_histories, -> { order('solution_histories.seq') }, dependent: :destroy

  has_many :integrated_contributes, dependent: :delete_all
  has_many :contributes, class_name: 'ProposalComment', through: :integrated_contributes, source: :proposal_comment
end
