class SysFeature < ActiveRecord::Base

  has_many :sys_payment_notifications

  def paypal_url(return_url,notify_url)
    "<script src=\"/assets/paypal-button.min.js?merchant=#{PAYPAL['paypal_merchant']}\"
    data-button=\"donate\"
    data-name=\"#{self.title}\"
    data-number=\"#{self.id}\"
    data-quantity=\"1\"
    data-env=\"#{Rails.env == 'production' ? 'www' : 'sandbox'}\"
    data-callback=\"#{notify_url}\"
    data-return=\"#{return_url}\"
    ></script>".html_safe
  end


  def amount_received_calc
    self.sys_payment_notifications.sum(:payment_gross)
  end
end
