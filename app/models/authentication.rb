#encoding: utf-8
class Authentication < ActiveRecord::Base
  FACEBOOK = "facebook"
  GOOGLE = "google_oauth2"
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
end

