class Tutorial < ActiveRecord::Base
  
  WELCOME = Tutorial.find_by_name("Welcome Tutorial")
  FIRST_PROPOSAL = Tutorial.find_by_name("First Proposal")
  RANK_BAR = Tutorial.find_by_name("Rank Bar")
  
  has_many :steps, :class_name => 'Step', :order => "index asc", :dependent => :destroy
  has_many :assignees, :class_name => 'TutorialAssignee', :dependent => :destroy
  has_many :users, :through => :assignees, :class_name => 'User'
end
