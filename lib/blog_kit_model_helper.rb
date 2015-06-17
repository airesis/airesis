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

    if user.avatar.exists?
      user.avatar.url
    else
      # Gravatar
      require 'digest/md5'
      if !user.email.blank?
        email = user.email
      else
        return ''
      end

      hash = Digest::MD5.hexdigest(email.downcase)
      "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
    end
  end

  def user_image_tag(size=80, params={})
    size= size || 80
    url= params[:url]
    certification_logo= params[:cert].nil? ? true : params[:cert]
    force_size= params[:force_size].nil? ? true : params[:force_size]

    user = self.respond_to?(:user) ? self.user : self

    if user.certified? && certification_logo && size < 60
      size = size - 6
    end

    style= force_size ? "style=\"width:#{size}px;height:#{size}px;\"" : ""

    ret = "<img src=\"#{user.user_image_url(size, params)}\" #{style} alt=\"\" itemprop=\"photo\" />"

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
