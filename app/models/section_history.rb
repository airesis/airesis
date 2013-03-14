class  SectionHistory < ActiveRecord::Base
  has_one :revision_section_history
  has_one :solution_section_history
  has_one :proposal_revision, :through => :revision_section_history
  has_one :solution, :through => :solution_section_history, class_name: 'SolutionHistory'
  has_many :paragraphs, :dependent => :destroy, class_name:  'ParagraphHistory'

end