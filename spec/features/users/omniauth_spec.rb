require 'spec_helper'
require 'requests_helper'

describe 'the oauth2 process', type: :feature, js: true do

  describe 'Tecnologie Democratiche' do

    before :each do
      @oauth_data = {
        provider: 'tecnologiedemocratiche',
        uid: Faker::Number.number(10),
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }

      OmniAuth.config.mock_auth[:tecnologiedemocratiche] = OmniAuth::AuthHash.new({
        provider: @oauth_data[:provider],
        credentials: {
          token: 'TDtoken'
        },
        uid: @oauth_data[:uid],
        info: {
          email: @oauth_data[:email],
          name: @oauth_data[:first_name],
          last_name: @oauth_data[:last_name]
        }
      })
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:tecnologiedemocratiche]
    end

    it 'permits to sign in creating a new user' do
      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t("devise.omniauth_callbacks.success")}/i)
      user_full_name = "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}"
      expect(page).to have_content(/#{user_full_name}/i)
      expect(User.count).to eq(1)
      expect(User.last.user_type_id).to eq(UserType::CERTIFIED)
    end

    it 'permits to sign in joining an existing account if email matches' do
      user = create(:user, email: @oauth_data[:email])
      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
      expect(User.count).to eq(1)
      user.reload
      expect(user.user_type_id).to eq(UserType::CERTIFIED)
    end

    it 'permits the join with an existing account' do
      user = create(:user)
      login user, 'topolino'

      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      user.reload
      expect(user.user_type_id).to eq(UserType::CERTIFIED)
      expect(user.name).to eq(@oauth_data[:first_name])
      expect(user.surname).to eq(@oauth_data[:last_name])
      expect(user.email).to eq(@oauth_data[:email])
    end

    it "doesn't permit the join if TD account is already taken" do
      user = create(:user)
      login user, 'topolino'
      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user
      visit '/'

      user2 = create(:user)
      login user2, 'topolino'
      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_failure', provider: @oauth_data[:provider].capitalize)}/i)
    end

    it "remembers TD account after joining" do
      user = create(:user)
      login user, 'topolino'
      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user
      visit '/'

      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.sessions.user.signed_in')}/i)
    end
end

end

