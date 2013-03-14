class  SolutionSectionHistory < ActiveRecord::Base
  belongs_to :solution_history
  belongs_to :section_history, :dependent => :destroy
end