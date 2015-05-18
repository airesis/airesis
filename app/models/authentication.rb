#encoding: utf-8
class Authentication < ActiveRecord::Base
  FACEBOOK = "facebook"
  GOOGLE = "google_oauth2"
  TWITTER = "twitter"
  MEETUP = "meetup"
  LINKEDIN = "linkedin"
  OPENID = "openid"
  PARMA = "parma"
  TECNOLOGIEDEMOCRATICHE = "tecnologiedemocratiche"
  belongs_to :user, class_name: 'User', foreign_key: :user_id
end