module Rack
  class Attack
    Rack::Attack.blocklist('bad-robots') do |req|
      /\S+\.php/.match?(req.path) ||
        CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
        req.path.include?('wp-admin') ||
        req.path.include?('wp-login') ||
        req.path.include?('/etc/passwd')
      req.path.include?('ads.txt')
    end
  end
end
