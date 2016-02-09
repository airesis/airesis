module PaypalHelper
  def paypal_button(args = {})
    content_tag(:script, nil, src: "#{asset_path('paypal-button.min.js')}?merchant=#{ENV['PAYPAL_MERCHANT']}",
                              data: {
                                button: args[:button] || 'donate',
                                name: args[:name] || 'Airesis',
                                number: args[:number] || 1,
                                size: args[:size] || 'small',
                                currency: args[:currency] || 'EUR',
                                amount: args[:amount] || '',
                                quantity: args[:quantity] || 1,
                                lc: I18n.locale,
                                env: Rails.env.production? ? '' : 'sandbox'
                              })
  end
end
