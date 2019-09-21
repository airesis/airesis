class UserType < ActiveRecord::Base
  ADMINISTRATOR = 1
  AUTHENTICATED = 3

  has_many :users, class_name: 'User'
end
