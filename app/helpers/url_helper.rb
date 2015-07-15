module UrlHelper
  def with_subdomain(options)
    subdomain = (options.delete(:subdomain) || '')
    subdomain += '.' unless subdomain.empty?
    subdomain += 'www.' if (!(defined? request) || !request || !request.subdomain.empty?) && (subdomain.empty?)
    host = options[:host] || (((defined? request) && request) ? request.domain : Rails.application.config.action_mailer.default_url_options[:host])
    if Rails.env.test?
      options[:host] = '127.0.0.1'
    else
      host = host.gsub('www.','').split(':')[0]
      options[:host] = [subdomain, host].join
    end
  end

  def url_for(options = nil)
      if options.kind_of?(Hash) && options.has_key?(:subdomain)
      with_subdomain(options)
      super
    elsif options.kind_of?(Group)
      if !request.subdomain.empty? && options.certified
        options = '/'
      end
      super
    elsif options.kind_of?(Array) && (options[0].instance_of? Group)
      if !['','www'].include? request.subdomain.to_s
        options.shift
        super options
      else
        super
      end
    elsif options.kind_of? String
      super
    else
      super
    end
  end
end
