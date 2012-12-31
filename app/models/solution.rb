class  Solution < ActiveRecord::Base
  belongs_to :proposal
  has_many :solution_sections
  has_many :sections, :through => :solution_sections
end