class  SolutionHistory < ActiveRecord::Base
  belongs_to :proposal_revision
  has_many :solution_section_histories, dependent: :destroy
  has_many :section_histories, through: :solution_section_histories, dependent: :destroy
end
