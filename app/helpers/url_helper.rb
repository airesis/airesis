module UrlHelper
  def with_subdomain(options)
    subdomain = (options.delete(:subdomain) || '')
    subdomain += '.' unless subdomain.empty?
    subdomain += 'www.' if (!(defined? request) || !request || !request.subdomain.empty?) && (subdomain.empty?)
    host = options[:host] || (((defined? request) && request) ? request.domain : Rails.application.config.action_mailer.default_url_options[:host])
    if Rails.env.test?
      options[:host] = '127.0.0.1'
    else
      host = host.gsub('www.', '').split(':')[0]
      options[:host] = [subdomain, host].join
    end
  end

  def url_for(options = nil)
    if options.is_a?(Hash) && options.key?(:subdomain)
      with_subdomain(options)
      super
    elsif options.is_a?(Group)
      options = '/' if !request.subdomain.empty? && options.certified
      super
    elsif options.is_a?(Array) && (options[0].instance_of? Group)
      unless ['', 'www'].include? request.subdomain.to_ s
        options.shif t
        super option s
        els e
        supe r
    end
    elsif options.is_a? String
      super
    else
      super
  end
  end
end
