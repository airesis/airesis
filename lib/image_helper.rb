module ImageHelper
  
  def group_image_tag(size=80)
    if self.respond_to?(:group)
      group = self.group
    else
      group = self
    end
    
    if group && !group.image_url.blank?
      # Load image from model
      ret = "<img src=\"#{group.image_url}\"  style=\"width:#{size}px;height:#{size}px;\" alt=\"\" onerror=\"deleteMe(this);\" />"
    else
      ret = "<img src=\"/assets/gruppo-anonimo.png\"  style=\"width:#{size}px;height:#{size}px;\" alt=\"\" onerror=\"deleteMe(this);\" />"
    end
    return ret.html_safe
  end
    
end