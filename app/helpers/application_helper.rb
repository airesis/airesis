module ApplicationHelper

  # ricarica i messaggi flash
  def reload_flash
    page.replace "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
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

  # return the time in words
  def time_in_words(from_time, include_seconds = false)
    diff = Time.now - from_time # difference of time from now
    if !from_time.today? # if it's not today
      if diff < 7.days && (from_time.wday <= Time.now.wday) # if time in this
        if (Time.now.day - from_time.day) == 1 # if it was yesterady
          ret = I18n.l(from_time, format: :yesterday_at)
        else
          ret = I18n.l(from_time, format: :weekday) # this week
        end
      else       
        ret = I18n.l(from_time, format: :short) # another week
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
    image_tag(url, alt: 'Google Authenticator QRCode')
  end

  def flag_for(title, key)
    link_to (image_tag "flags/#{key}.png", alt: title, class: 'flag-icon'), current_url(l: key), title: title
  end

  def body_page_name
    [controller_name.camelcase, action_name.camelcase].join if response.ok?
  end

end
