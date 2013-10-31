class SysFeature < ActiveRecord::Base

  def paypal_url
    "<script src=\"/assets/paypal-button.min.js?merchant=X25TSHNPP9NUJ\"
    data-button=\"donate\"
    data-name=\"#{self.title}\"
    data-quantity=\"1\"
    data-env=\"sandbox\"
    data-callback=\"http://www.airesisdev.it:3000/sys_features/ipn\"
    data-return=\"http://www.airesisdev.it:3000/sys_features/#{self.id}\"
    ></script>".html_safe
  end
end
