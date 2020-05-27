class Section < ApplicationRecord
  has_one :proposal_section, inverse_of: :section, dependent: :delete
  has_one :solution_section, inverse_of: :section, dependent: :delete
  has_one :proposal, through: :proposal_section
  has_one :solution, through: :solution_section
  has_many :paragraphs, dependent: :destroy

  has_many :proposal_comments, through: :paragraphs

  validates :title, length: { in: 1..100 }

  accepts_nested_attributes_for :paragraphs

  attr_accessor :suggestion

  def paragraph
    paragraphs.first
  end
end
