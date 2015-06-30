class OauthDataParser

  def initialize(data)
    @data = data
  end

  def data
    @data
  end

  def raw_info
    @raw_info ||= data['raw_info'] || # TD
                  data['extra'].try(:[], 'raw_info') || # Meetup, Twitter, Google, Linkedin, FB
                  data['info'] # Parma
  end

  def provider
    @provider ||= data['provider'].to_s
  end

  def uid
    @uid ||= data['uid'].to_s
  end

  def user_info
    @user_info ||= Hash.new.tap do |info|
                     info[:email] = user_email
                     info[:name] = user_name
                     info[:surname] = user_surname
                     info[:sex] = user_sex
                     info[:email_verified] = user_email_verified?
                     info[:avatar_url] = user_avatar_url
                     info[:certified] = user_certified?
                   end
  end

  def user_name
    if [ Authentication::TWITTER, Authentication::MEETUP ].include? provider
      fullname = raw_info['name']
      splitted = fullname.split(' ', 2)
      splitted ? splitted[0] : fullname
    else
      raw_info['first_name'] || # Parma, Facebook
      raw_info['given_name'] || # Google
      raw_info['firstName'] || # Linkedin
      raw_info['name'] # TD
    end
  end

  def user_surname
    if [ Authentication::TWITTER, Authentication::MEETUP ].include? provider
      fullname = raw_info['name']
      splitted = fullname.split(' ', 2)
      splitted ? splitted[1] : ''
    else
      raw_info['last_name'] || # TD, Parma, Facebook
      raw_info['family_name'] || # Google
      raw_info['lastName'] # Linkedin
    end
  end

  def user_email
    @user_email ||= raw_info['email'] || # TD, Parma, Google, FB
                    data['info']['email'] # Linkedin
  end

  def user_sex
    @user_sex ||= (raw_info['gender'] ? raw_info['gender'][0] : nil)
  end

  def user_avatar_url
    @user_avatar_url ||= raw_info['picture'] || # Google
                         raw_info['pictureUrl'] || # Linkedin
                         raw_info['profile_image_url'] || # Twitter
                         raw_info['photo'].try(:[], 'photo_link') || # Meetup
                         data['info'].try(:[], 'image') # Facebook
  end

  def user_certified?
    provider == Authentication::TECNOLOGIEDEMOCRATICHE ||
    (provider == Authentication::PARMA && raw_info['verified'])
  end

  # !!! TODO: verificare che gli indirizzi email ricevuti dagli altri provider siano verificati !!!
  def user_email_verified?
    case provider
      when Authentication::FACEBOOK then raw_info['verified']
      when Authentication::GOOGLE then true
      else true
    end
  end
end
