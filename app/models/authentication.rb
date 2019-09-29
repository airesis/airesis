class Authentication < ActiveRecord::Base
  FACEBOOK = 'facebook'
  GOOGLE = 'google_oauth2'
  TWITTER = 'twitter'
  belongs_to :user, class_name: 'User', foreign_key: :user_id
end
