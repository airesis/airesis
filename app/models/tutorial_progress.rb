class TutorialProgress < ApplicationRecord
  TODO = 'N'.freeze
  DONE = 'Y'.freeze
  SKIPPED = 'S'.freeze

  belongs_to :step, class_name: 'Step'
  belongs_to :user, class_name: 'User'
end
