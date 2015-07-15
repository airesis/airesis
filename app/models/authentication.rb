class Authentication < ActiveRecord::Base
  before_destroy :can_be_destroyed?

  FACEBOOK = 'facebook'
  GOOGLE = 'google_oauth2'
  TWITTER = 'twitter'
  MEETUP = 'meetup'
  LINKEDIN = 'linkedin'
  OPENID = 'openid'
  PARMA = 'parma'
  TECNOLOGIEDEMOCRATICHE = 'tecnologiedemocratiche'
  belongs_to :user, class_name: 'User', foreign_key: :user_id

  UNDETACHABLE_PROVIDERS = [ TECNOLOGIEDEMOCRATICHE ]

protected

  def can_be_destroyed?
    UNDETACHABLE_PROVIDERS.exclude? provider
  end

end
