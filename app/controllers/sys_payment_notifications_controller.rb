class SysPaymentNotificationsController < ApplicationController
  protect_from_forgery except: :create

  def create
    response = validate_IPN_notification(request.raw_post)
    case response
      when "VERIFIED"
        SysPaymentNotification.create!(params: params, payable_id: (params[:item_number].to_i rescue nil), payable_type: (Object.const_defined?(params[:atype]) ? params[:atype] : nil), status: params[:payment_status], transaction_id: params[:txn_id], payment_fee: params[:mc_fee], payment_gross: params[:mc_gross], first_name: params[:first_name], last_name: params[:last_name])
      when "INVALID"
        log_error Exception.new('invalid ipn received')
      else
        # error
    end
    render nothing: true
  end

  protected
  def validate_IPN_notification(raw)
    uri = URI.parse("#{PAYPAL['paypal_url']}?cmd=_notify-validate")
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, raw,
                         'Content-Length' => "#{raw.size}",
                         'User-Agent' => "My custom user agent"
    ).body
  end
end
