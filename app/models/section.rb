class  Section < ActiveRecord::Base
  has_one :proposal_section
  has_one :solution_section
  has_one :proposal, through: :proposal_section
  has_one :solution, through: :solution_section
  has_many :paragraphs, dependent: :destroy

  has_many :proposal_comments, through: :paragraphs

  #attr_accessible :paragraphs

  accepts_nested_attributes_for :paragraphs

end