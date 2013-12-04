require 'omniauth/strategies/oauth2'
require 'base64'
require 'openssl'
require 'rack/utils'

module OmniAuth
  module Strategies
    class Parma < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError;
      end

      DEFAULT_SCOPE = 'email'

      option :client_options, {
          :site => 'https://oauth2.comune.parma.it',
          :authorize_url => "/Authorization",
          :token_url => '/Token/OpenGet'
      }

      option :token_params, {
          :parse => :json
      }

      option :access_token_options, {
          :header_format => 'OAuth %s',
          :param_name => 'access_token'
      }


      option :authorize_options, [:scope, :display, :auth_type]

      option :provider_ignores_state, true

      uid {
        raw_info['id']
      }

      info do
        prune!({
                   'nickname' => raw_info['username'],
                   'email' => raw_info['email'],
                   'name' => raw_info['name'],
                   'first_name' => raw_info['first_name'],
                   'last_name' => raw_info['last_name'],
                   'image' => image_url(uid, options),
                   'description' => raw_info['bio'],
                   'urls' => {
                       'Facebook' => raw_info['link'],
                       'Website' => raw_info['website']
                   },
                   'location' => (raw_info['location'] || {})['name'],
                   'verified' => raw_info['verified']
               })
      end

      extra do
        hash = {}
        hash['raw_info'] = raw_info unless skip_info?
        prune! hash
      end

      def raw_info
        #@raw_info ||= access_token.get('/me', info_options).parsed || {} #todo
        @raw_info
      end

      def request_phase
        super
      end

    end
  end
end
