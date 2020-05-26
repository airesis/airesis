module ImageHelper
  def group_image_tag(size = 80, url = false)
    group = respond_to?(:group) ? self.group : self

    src = group.image.url
    src = "#{ENV['SITE']}#{src}" if url
    style = size ? "width:#{size}px;height:#{size}px;overflow:hidden;" : ''
    ret = "<img src=\"#{src}\"  style=\"#{style}\" alt=\"#{group.name}\" />"
    ret.html_safe
  end
end
