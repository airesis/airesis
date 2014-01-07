#encoding: utf-8
module EmailHelper

  def blue_panel(&block)
    "<table class=\"row callout\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; position: relative; display: block; padding: 0px;\">
   <tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">
   <td class=\"wrapper last\" style=\"word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; position: relative; padding: 10px 0px 20px;\" align=\"left\" valign=\"top\">
   <table class=\"twelve columns\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 580px; margin: 0 auto; padding: 0;\">
   <tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">
   <td class=\"panel\" style=\"word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; background: #ECF8FF; padding: 10px; border: 1px solid #b9e5ff;\" align=\"left\" bgcolor=\"#ECF8FF\" valign=\"top\">
   <p style=\"color: #222222; font-family: 'Helvetica', 'Arial', sans-serif; font-weight: normal; text-align: left; line-height: 19px; font-size: 14px; margin: 0; padding: 0 0 10px;\" align=\"left\">
   #{capture(&block)}
            </p>
   </td>
          <td class=\"expander\" style=\"word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; visibility: hidden; width: 0px; padding: 0;\" align=\"left\" valign=\"top\"></td>
   </tr>
      </table>
   </td>
  </tr>
   </table>".html_safe
  end

  def section_panel(&block)
    "<table class=\"row callout\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 100%; position: relative; display: block; padding: 0px;\">
      <tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">
       <td class=\"wrapper last\" style=\"word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; position: relative; padding: 10px 0px 20px;\" align=\"left\" valign=\"top\">
        <table class=\"twelve columns\" style=\"border-spacing: 0; border-collapse: collapse; vertical-align: top; text-align: left; width: 580px; margin: 0 auto; padding: 0;\">
         <tr style=\"vertical-align: top; text-align: left; padding: 0;\" align=\"left\">
          <td class=\"panel\" style=\"word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; background: #ebebeb; padding: 10px; border: 1px solid #ccc;\" align=\"left\" bgcolor=\"#ebebeb\" valign=\"top\">
           #{capture(&block)}
          </td>
          <td class=\"expander\" style=\"word-break: break-word; -webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto; border-collapse: collapse !important; vertical-align: top; text-align: left; visibility: hidden; width: 0px; padding: 0;\" align=\"left\" valign=\"top\"></td>
         </tr>
       </table>
      </td>
     </tr>
    </table>".html_safe
  end
  
  def email_h1(&block)
    "<h1 style=\"color: #222222; font-family: 'Helvetica', 'Arial', sans-serif; font-weight: normal; text-align: left; line-height: 1.3; word-break: normal; font-size: 40px; margin: 0; padding: 0;\" align=\"left\">
    #{capture(&block)}
    </h1>".html_safe
  end
  
  def email_h3(&block)
    "<h3 style=\"color: #222222; font-family: 'Helvetica', 'Arial', sans-serif; font-weight: normal; text-align: left; line-height: 1.3; word-break: normal; font-size: 32px; margin: 0; padding: 0;\" align=\"left\">
    #{capture(&block)}</h3>".html_safe
  end
  
  def email_h5(&block)
    "<h5 style=\"color: #222222; font-family: 'Helvetica', 'Arial', sans-serif; font-weight: normal; text-align: left; line-height: 1.3; word-break: normal; font-size: 24px; margin: 0; padding: 0 0 10px;\" align=\"left\">
    #{capture(&block)}</h5>".html_safe
  end
end
