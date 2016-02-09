require 'omniauth/strategies/oauth2'
require 'base64'
require 'openssl'
require 'rack/utils'

module OmniAuth
  module Strategies
    class Parma < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError
      end

      DEFAULT_SCOPE = 'email'

      option :client_options,           site: 'https://oauth2.comune.parma.it',
                                        authorize_url: '/Authorization',
                                        token_url: '/Token/OpenGet'

      option :token_params, parse: :json

      option :access_token_options,           header_format: 'OAuth %s',
                                              param_name: 'access_token'

      option :authorize_options, [:scope, :display, :auth_type]

      option :provider_ignores_state, true

      uid do
        raw_info['email']
      end

      info do
        {
          'email' => raw_info['email'],
          'first_name' => raw_info['nome'],
          'last_name' => raw_info['cognome'],
          'verified' => raw_info['residente'] || false
        }
      end

      extra do
        hash = {}
        hash['raw_info'] = raw_info unless skip_info?
      end

      def raw_info
        access_token.options[:mode] = :body
        access_token.options[:param_name] = :token
        @raw_info ||= access_token.post('/Cittadino/About').parsed
      end

      def request_phase
        super
      end
    end
  end
end
