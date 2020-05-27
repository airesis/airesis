class GroupFollow < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :group, class_name: 'Group', foreign_key: :group_id
end
