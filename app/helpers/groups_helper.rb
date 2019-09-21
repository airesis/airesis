module GroupsHelper
  # TODO: to be moved as soon as possible
  def check_alert_url(alert, options = {})
    subdomain = alert.notification.data[:subdomain]
    options[:subdomain] = subdomain if subdomain.to_s != ''
    super
  end
end
