class Authentication < ApplicationRecord
  FACEBOOK = 'facebook'.freeze
  GOOGLE = 'google_oauth2'.freeze
  TWITTER = 'twitter'.freeze
  belongs_to :user, class_name: 'User', foreign_key: :user_id
end
