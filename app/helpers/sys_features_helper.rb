module SysFeaturesHelper
  def sys_feature_paypal_url(sys_feature)
    "<script src=\"#{asset_path('paypal-button.min.js')}?merchant=#{PAYPAL['paypal_merchant']}\"
    data-button=\"donate\"
    data-name=\"#{sys_feature.title}\"
    data-number=\"#{sys_feature.id}\"
    data-atype=\"feature\"
    data-quantity=\"1\"
    data-currency=\"EUR\"
    data-env=\"#{Rails.env.production? ? '' : 'sandbox'}\"
    data-callback=\"#{donations_url}\"
    data-return=\"#{sys_payment_notifications_url}\"
    ></script>".html_safe
  end
end
