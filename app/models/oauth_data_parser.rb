class OauthDataParser
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def raw_info
    @raw_info ||= data['extra'].try(:[], 'raw_info') # Meetup, Twitter, Google, Linkedin, FB
  end

  def provider
    @provider ||= data['provider'].to_s
  end

  def uid
    @uid ||= data['uid'].to_s
  end

  def user_info
    @user_info ||= {}.tap do |info|
      info[:email] = user_email
      info[:name] = user_name
      info[:surname] = user_surname
      info[:sex] = user_sex
      info[:verified] = verified?
      info[:avatar_url] = user_avatar_url
    end
  end

  def user_name
    if [Authentication::TWITTER, Authentication::MEETUP].include? provider
      fullname = raw_info['name']
      splitted = fullname.split(' ', 2)
      splitted ? splitted[0] : fullname
    else
      raw_info['first_name'] || # Facebook
        raw_info['given_name'] || # Google
        raw_info['firstName'] # Linkedin
    end
  end

  def user_surname
    if [Authentication::TWITTER, Authentication::MEETUP].include? provider
      fullname = raw_info['name']
      splitted = fullname.split(' ', 2)
      splitted ? splitted[1] : ''
    else
      raw_info['last_name'] || # Facebook
        raw_info['family_name'] || # Google
        raw_info['lastName'] # Linkedin
    end
  end

  def user_email
    @user_email ||= raw_info['email'] || # Google, FB
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
      "#{data['info'].try(:[], 'image')}?type=large" # Facebook
  end

  def verified?
    case provider
    when Authentication::FACEBOOK
      raw_info['verified']
    else
      true
    end
  end
end
