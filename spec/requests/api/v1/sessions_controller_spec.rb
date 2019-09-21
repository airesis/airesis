require 'rails_helper'

RSpec.describe Api::V1::SessionsController do
  describe '#create' do
    let(:user) { create(:user) }

    def perform_request
      post api_v1_login_path, params: { user: { email: user.email, password: user.password } }
    end

    before { perform_request }

    it 'can authenticate a user via username and password and return a token' do
      expect(JSON.parse(response.body, symbolize_names: true)).
        to match(data: a_hash_including(:authentication_token, message: I18n.t('api.v1.sessions.create.message')),
                 success: true)
    end
  end
end
