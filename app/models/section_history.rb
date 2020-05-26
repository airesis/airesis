class SectionHistory < ApplicationRecord
  has_one :revision_section_history, inverse_of: :section_history
  has_one :solution_section_history, inverse_of: :section_history
  has_one :proposal_revision, through: :revision_section_history
  has_one :proposal, through: :proposal_revision
  has_one :solution, through: :solution_section_history, class_name: 'SolutionHistory'
  has_many :paragraphs, class_name: 'ParagraphHistory', inverse_of: :section, dependent: :destroy
  validates :title, length: { in: 1..100 }
end
