class Step < ActiveRecord::Base
  belongs_to :tutorial, :class_name => 'Tutorial'
  has_many :tutorial_progresses, :class_name => 'TutorialProgress', :dependent => :destroy

end
