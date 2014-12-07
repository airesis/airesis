#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :facebook,  "242345195791486", "effb2e9b6fb07ce738452c8b3c1a0f57"
#end

if Rails.env.production?
  module OmniAuth
    module Strategy
      def full_host
        uri = URI.parse(request.url)
        uri.path = ''
        uri.query = nil
        uri.port = (uri.scheme == 'https' ? 443 : 80)
        uri.to_s
      end
    end
  end
end
