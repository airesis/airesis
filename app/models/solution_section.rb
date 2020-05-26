class SolutionSection < ApplicationRecord
  belongs_to :solution, inverse_of: :solution_sections
  belongs_to :section, inverse_of: :solution_section, dependent: :destroy
end
