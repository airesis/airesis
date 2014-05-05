class UserType < ActiveRecord::Base
  AUTHENTICATED = 3
  CERTIFIED = 5

  has_many :users, class_name: 'User'
end
