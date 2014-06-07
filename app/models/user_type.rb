class UserType < ActiveRecord::Base
  ADMINISTRATOR = 1
  AUTHENTICATED = 3
  CERTIFIED = 5

  has_many :users, class_name: 'User'
end
