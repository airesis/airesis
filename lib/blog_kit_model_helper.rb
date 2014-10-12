#encoding: utf-8

require 'rubygems'
require 'sanitize'


module BlogKitModelHelper

  def truncate_words(text, length = 30, end_string = ' ...')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end


  def user_image_url(size=80, params={})
    url= params[:url]
    certification_logo= params[:cert].nil? ? true : params[:cert]
    force_size= params[:force_size].nil? ? true : params[:force_size]

    if self.respond_to?(:user)
      user = self.user
    else
      user = self
    end

    if user.certified? && certification_logo && size < 60
      size = size-6
    end

    if user.avatar_file_name.present?
      ret = user.avatar.url
    elsif user.has_provider?(Authentication::FACEBOOK)
      if size <= 50
        fsize = 'small'
      elsif size <= 100
        fsize = 'normal'
      else
        fsize = 'large'
      end
      uid = user.authentications.find_by_provider(Authentication::FACEBOOK).uid
      ret = "https://graph.facebook.com/#{uid}/picture?type=#{fsize}"
    elsif user.has_provider?(Authentication::GOOGLE)
      uid = user.authentications.find_by_provider(Authentication::GOOGLE).uid
      ret = "https://www.google.com/s2/photos/profile/#{uid}?sz=#{fsize}"
    else
      # Gravatar
      require 'digest/md5'
      if !user.email.blank?
        email = user.email
      else
        return ''
      end

      hash = Digest::MD5.hexdigest(email.downcase)
      ret = "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
    end
    ret
  end

  def user_image_tag(size=80, params={})
    size= size || 80
    url= params[:url]
    certification_logo= params[:cert].nil? ? true : params[:cert]
    force_size= params[:force_size].nil? ? true : params[:force_size]


    if self.respond_to?(:user)
      user = self.user
    else
      user = self
    end

    if user.certified? && certification_logo && size < 60
      size = size-6
    end

    style= force_size ? "style=\"width:#{size}px;height:#{size}px;\"" : ""

    if size <= 50
      fsize = 'small'
    elsif size <= 100
      fsize = 'normal'
    else
      fsize = 'large'
    end

    if user.avatar_file_name.present?
      ret = "<img src=\"#{user.avatar.url}\" #{style} alt=\"\" itemprop=\"photo\" />"
    elsif user.has_provider?(Authentication::FACEBOOK)
      uid = user.authentications.find_by_provider(Authentication::FACEBOOK).uid
      ret = "<img src=\"https://graph.facebook.com/#{uid}/picture?type=#{fsize}\" #{style} alt=\"\" itemprop=\"photo\" />"
    elsif user.has_provider?(Authentication::GOOGLE)
      uid = user.authentications.find_by_provider(Authentication::GOOGLE).uid
      ret = "<img src=\"https://www.google.com/s2/photos/profile/#{uid}?sz=#{fsize}\" #{style} alt=\"\" itemprop=\"photo\" />"
    else
      # Gravatar
      require 'digest/md5'
      if user.email.blank?
        return ''
      else
        email = user.email
      end

      hash = Digest::MD5.hexdigest(email.downcase)
      ret = "<img  src=\"http://www.gravatar.com/avatar/#{hash}?s=#{size}\"  itemprop=\"photo\" />"
    end

    if user.certified? && certification_logo
      if size >= 60
        ret = "<div class=\"user_certified\">#{ret}<img class=\"certification\" src=\"#{url ? Maktoub.home_domain : ''}/assets/certification.png\"/></div>"
      else
        ret = "<div class=\"user_certified_mini\"  style=\"width:#{size+6}px;height:#{size+6}px;\">#{ret}</div>"
      end
    end
    ret.html_safe
  end
end
