class SysFeature < ActiveRecord::Base

  has_many :sys_payment_notifications, as: :payable

  # Check for paperclip
  has_attached_file :image,
                    styles: {
                        medium: "300x300>"
                    },
                    url: "/assets/images/sys_features/:id/:style/:basename.:extension",
                    path: ":rails_root/public/assets/images/sys_features/:id/:style/:basename.:extension"

  def paypal_url(return_url,notify_url)
    "<script src=\"/assets/paypal-button.min.js?merchant=#{PAYPAL['paypal_merchant']}\"
    data-button=\"donate\"
    data-name=\"#{self.title}\"
    data-number=\"#{self.id}\"
    data-atype=\"feature\"
    data-quantity=\"1\"
    data-currency=\"EUR\"
    data-env=\"#{Rails.env == 'production' ? '' : 'sandbox'}\"
    data-callback=\"#{notify_url}\"
    data-return=\"#{return_url}\"
    ></script>".html_safe
  end


  def amount_received_calc
    self.sys_payment_notifications.sum(:payment_gross)
  end
end
