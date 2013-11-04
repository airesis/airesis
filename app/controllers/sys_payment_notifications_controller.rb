class SysPaymentNotificationsController < ApplicationController
  protect_from_forgery except: :create

  def create
    response = validate_IPN_notification(request.raw_post)
    case response
      when "VERIFIED"
        SysPaymentNotification.create!(:params => params, :sys_feature_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id], payment_fee: params[:payment_fee], payment_gross: params[:payment_gross], first_name: params[:first_name], last_name: params[:last_name])
      when "INVALID"
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
