class UserType < ActiveRecord::Base
  CERTIFIED = 5

  has_many :users, :class_name => 'User'
end
