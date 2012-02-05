class InfoTagBuilder < ActionView::Helpers::FormBuilder
 include ActionView::Helpers::FormTagHelper
 include ActionView::Helpers::AssetTagHelper 
 
  # Accepts an int and displays a smiley based on >, <, or = 0
  def info_tag(method, options = {})
    ret = "<div class=\"bubbleInfo\">".html_safe
    ret += label(method)
    ret += "<br/>".html_safe
    ret += text_field(method,:class=> "trigger")
    
    ret += "<div class='popup' style='top: -90px;  width: 300px;'>
        <table id='dpop' class='popup'>
        <tbody><tr>
        <td id=\"topleft\" class=\"corner\"></td>
        <td class=\"top\"></td>
        <td id=\"topright\" class=\"corner\"></td>
        </tr>
        <tr>
        <td class=\"left\"></td>
        <td><table class=\"popup-contents\">
        <tbody><tr>
                <th>".html_safe
    ret += label(method)
    ret += "</th>     
              </tr>
              <tr>                
                <td>".html_safe
    ret += options[:help]
    ret +="</td>
              </tr>
              
            </tbody></table>

            </td>
            <td class=\"right\"></td>    
          </tr>

          <tr>
            <td class=\"corner\" id=\"bottomleft\"></td>
            <td class=\"bottom\">".html_safe
              
     ret += @template.image_tag("bubble-tail2.png")
     ret += "
            </td>
            <td id=\"bottomright\" class=\"corner\"></td>
          </tr>
        </tbody></table>
      </div>".html_safe
    
    ret += "</div>".html_safe
    return ret
    
#     
    # value = @object.nil? ? 0 : @object.send(method).to_i
    # options[:id] = field_id(method,options[:index])
    # smiley = ":-|"
    # if value > 0
      # smiley = ":-)"
    # elsif smiley < 0
       # smiley = ":-(" 
    # end
    # return text_field_tag(field_name(method,options[:index]),options) + smiley
  end

  def field_name(label,index=nil)
    output = index ? "[#{index}]" : ''
    return @object_name + output + "[#{label}]"
  end

  def field_id(label,index=nil)
    output = index ? "_#{index}" : ''
    return @object_name + output + "_#{label}"
  end

end