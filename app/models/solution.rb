class Solution < ApplicationRecord
  belongs_to :proposal, inverse_of: :solutions
  has_many :solution_sections, inverse_of: :solution, dependent: :destroy
  has_many :sections, -> { order('sections.seq, sections.id') }, inverse_of: :solution, through: :solution_sections

  accepts_nested_attributes_for :sections, allow_destroy: true

  def title_with_seq
    solution_ids = proposal.solutions.pluck(:id)
    I18n.t("pages.proposals.edit.new_solution_title.#{proposal.proposal_type.name.downcase}", num: solution_ids.index(id) + 1) + title.to_s
  end
end
