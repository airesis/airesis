class SolutionSectionHistory < ActiveRecord::Base
  belongs_to :solution_history, inverse_of: :solution_section_histories
  belongs_to :section_history, inverse_of: :solution_section_history
end
