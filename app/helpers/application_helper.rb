#encoding: utf-8
module ApplicationHelper
  
  #ricarica i messaggi flash
  def reload_flash
    page.replace "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def facebook_like
    "<div class=\"fb-like\" data-send=\"false\" data-layout=\"box_count\" data-width=\"100\" data-show-faces=\"false\"></div>"
  end
  
  def calendar(*args)
    "<div id='calendar'></div>"
  end


 def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def time_in_words(from_time, include_seconds=false)
    diff = Time.now - from_time
    if diff > 24.hours
      if diff < 7.days && (from_time.wday <= Time.now.wday)
        if (Time.now.day - from_time.day) == 1
          ret = "Yesterday at #{I18n.l(from_time, format: :hour)}" if Time.now.day != from_time.day
        else
          ret = I18n.l(from_time, format: :weekday)
        end
      else
        ret = I18n.l(from_time, format: :short)
      end
    elsif diff > 1.hours
        ret = I18n.l(from_time, format: :hour)
    else
      ret = "<div data-countdown data-time='#{(from_time).to_i * 1000}' style='display:inline'></div>".html_safe
    end
    ret
  end


  def google_authenticator_qrcode(user)
    data = "otpauth://totp/#{user.email}?secret=#{user.rotp_secret}"
    url = "https://chart.googleapis.​com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{data}"
    image_tag(url, :alt => 'Google Authenticator QRCode')
  end


  def in_subdomain?
    request.subdomain.present? && request.subdomain != 'www'
  end
  
end
