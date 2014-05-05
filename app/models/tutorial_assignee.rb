class TutorialAssignee < ActiveRecord::Base
  belongs_to :tutorial, class_name: 'Tutorial'
  belongs_to :user, class_name: 'User'
end
