module UrlHelper

  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    host = Rails.application.config.action_mailer.default_url_options[:host]
    [subdomain, host].join
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))

    elsif options.kind_of?(Group)
      if !request.subdomain.empty? && options.certified
        options = '/'
      end
    elsif options.kind_of?(Array) && (options[0].instance_of? Group)
      if request.subdomain
        super options[1]
      else
        super
      end
    elsif options.kind_of? String
      super
    end
    super
  end
end