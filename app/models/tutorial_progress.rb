class TutorialProgress < ActiveRecord::Base
  TODO = 'N'
  DONE = 'Y'
  SKIPPED = 'S'

  belongs_to :step, class_name: 'Step'
  belongs_to :user, class_name: 'User'
end
