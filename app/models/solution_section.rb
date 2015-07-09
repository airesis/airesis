class SolutionSection < ActiveRecord::Base
  belongs_to :solution
  belongs_to :section, dependent: :destroy
end
