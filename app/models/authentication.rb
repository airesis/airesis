#encoding: utf-8
class Authentication < ActiveRecord::Base
  before_destroy :can_be_destroyed?, prepend: true

  FACEBOOK = "facebook"
  GOOGLE = "google_oauth2"
  TWITTER = "twitter"
  MEETUP = "meetup"
  LINKEDIN = "linkedin"
  OPENID = "openid"
  PARMA = "parma"
  TECNOLOGIEDEMOCRATICHE = "tecnologiedemocratiche"
  belongs_to :user, class_name: 'User', foreign_key: :user_id

  UNDETACHABLE_PROVIDERS = [ TECNOLOGIEDEMOCRATICHE ]


  def self.oauth_raw_info(oauth_data)
    oauth_data['raw_info'] || # TD
    oauth_data['extra'].try(:[], 'raw_info') || # Meetup, Twitter, Google, Linkedin, FB
    oauth_data['info'] # Parma
  end

  def self.oauth_provider(oauth_data)
    oauth_data['provider'].to_s
  end

  def self.oauth_uid(oauth_data)
    oauth_data['uid'].to_s
  end

  def self.oauth_user_info(oauth_data)

    provider = oauth_provider oauth_data
    raw_info = oauth_raw_info oauth_data

    Hash.new.tap do |user_info|
      user_info[:email] = raw_info['email'] || # TD, Parma, Google, FB
                          oauth_data['info']['email'] # Linkedin

      if [ Authentication::TWITTER, Authentication::MEETUP ].include? provider
        fullname = raw_info['name']
        splitted = fullname.split(' ', 2)
        user_info[:name] = splitted ? splitted[0] : fullname
        user_info[:surname] = splitted ? splitted[1] : ''
      else
        user_info[:name] = raw_info['first_name'] || # Parma, Facebook
                           raw_info['given_name'] || # Google
                           raw_info['firstName'] || # Linkedin
                           raw_info['name'] # TD

        user_info[:surname] = raw_info['last_name'] || # TD, Parma, Facebook
                              raw_info['family_name'] || # Google
                              raw_info['lastName'] # Linkedin
      end

      user_info[:sex] = raw_info['gender'] ? raw_info['gender'][0] : nil

      # !!! TODO: verificare che gli indirizzi email ricevuti dagli altri provider siano verificati !!!
      user_info[:email_verified] = case provider
                                   when Authentication::FACEBOOK then raw_info['verified']
                                   when Authentication::GOOGLE then true
                                   else true
                                   end

      user_info[:avatar_url] = raw_info['picture'] || # Google
                               raw_info['pictureUrl'] || # Linkedin
                               raw_info['profile_image_url'] || # Twitter
                               raw_info['photo'].try(:[], 'photo_link') || # Meetup
                               oauth_data['info'].try(:[], 'image') # Facebook

    end
  end

protected

  def can_be_destroyed?
    return false if UNDETACHABLE_PROVIDERS.include? self.provider
  end

end