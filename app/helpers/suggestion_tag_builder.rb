class SuggestionTagBuilder < ActionView::Helpers::FormBuilder
 include ActionView::Helpers::FormTagHelper
 include ActionView::Helpers::AssetTagHelper 
 
  # Accepts an int and displays a smiley based on >, <, or = 0
  def suggestion_tag(method, options = {})
    ret = 'hei'
    ret
  end

  def field_name(label,index=nil)
    output = index ? "[#{index}]" : ''
    @object_name + output + "[#{label}]"
  end

  def field_id(label,index=nil)
    output = index ? "_#{index}" : ''
    @object_name + output + "_#{label}"
  end
end
