class Tutorial < ApplicationRecord
  has_many :steps, -> { order 'index asc' }, class_name: 'Step', dependent: :destroy
  has_many :assignees, class_name: 'TutorialAssignee', dependent: :destroy
  has_many :users, through: :assignees, class_name: 'User'
end
