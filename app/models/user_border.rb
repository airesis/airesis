class UserBorder < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :interest_border, class_name: 'InterestBorder', foreign_key: :interest_border_id
end
