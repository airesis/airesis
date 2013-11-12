#encoding: utf-8

require 'rubygems'
require 'sanitize'
#TODO to remove in 3.0
begin
  require 'bluecloth'
rescue Exception => e
  require 'erb'
  puts "Could not load bluecloth #{e.inspect}"
end
begin
  require 'uv'
rescue Exception => e
  require 'erb'
  puts "Could not load UltraViolet"
end

module BlogKitModelHelper

  def truncate_words(text, length = 30, end_string = ' ...')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end


  def user_image_tag(size=80, url=false)
    if self.respond_to?(:user)
      user = self.user
    else
      user = self
    end

    if user && !user.image_url.blank?
      # Load image from model
      ret = url ?
          "<img src=\"#{Maktoub.home_domain}#{user.image_url}\"  style=\"width:#{size}px;height:#{size}px;\" alt=\"\" itemprop=\"photo\" />" :
          "<img src=\"#{user.image_url}\"  style=\"width:#{size}px;height:#{size}px;\" alt=\"\" itemprop=\"photo\" />"
    elsif user.has_provider(Authentication::FACEBOOK)
      if size <= 50
        fsize = 'small'
      elsif size <= 100
        fsize = 'normal'
      else
        fsize = 'large'
      end
      uid = user.authentications.find_by_provider(Authentication::FACEBOOK).uid
      ret = "<img src=\"https://graph.facebook.com/#{uid}/picture?type=#{fsize}\" style=\"width:#{size}px;height:#{size}px;\" alt=\"\" itemprop=\"photo\" />"
    elsif user.has_provider(Authentication::GOOGLE)
      uid = user.authentications.find_by_provider(Authentication::GOOGLE).uid
      ret = "<img src=\"https://www.google.com/s2/photos/profile/#{uid}?sz=#{fsize}\" style=\"width:#{size}px;height:#{size}px;\" alt=\"\" itemprop=\"photo\" />"
    else
      # Gravatar
      require 'digest/md5'
      if !user.email.blank?
        email = user.email
      else
        return ''
      end

      hash = Digest::MD5.hexdigest(email.downcase)
      ret = "<img  src=\"http://www.gravatar.com/avatar/#{hash}?s=#{size}\"  itemprop=\"photo\"/>"
    end

    return ret.html_safe if ret.respond_to?(:html_safe)
    ret
  end
end
