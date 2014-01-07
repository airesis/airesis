module ImageHelper
  
  def group_image_tag(size=80,url=false)
    if self.respond_to?(:group)
      group = self.group
    else
      group = self
    end

    src = (group.image_url.blank?) ? '/assets/gruppo-anonimo.png' : group.image_url
    src = Maktoub.home_domain + src if url
    style = size ? "width:#{size}px;height:#{size}px;" : ""
    ret = "<img src=\"#{src}\"  style=\"#{style}\" alt=\"#{group.name}\" onerror=\"deleteMe(this);\" />"
    ret.html_safe
  end
    
end