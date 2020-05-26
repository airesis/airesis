class SolutionHistory < ApplicationRecord
  belongs_to :proposal_revision, inverse_of: :solution_histories
  has_many :solution_section_histories, inverse_of: :solution_history, dependent: :destroy
  has_many :section_histories, through: :solution_section_histories, dependent: :destroy
end
