require 'spec_helper'
require 'requests_helper'

describe 'the oauth2 process', type: :feature, js: true do
  describe 'Facebook' do
    before :each do
      @oauth_data = {
        provider: 'facebook',
        uid: Faker::Number.number(10),
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }

      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: @oauth_data[:provider],
                                                                    uid: @oauth_data[:uid],
                                                                    info: {
                                                                      nickname: 'jbloggs',
                                                                      email: 'joe@bloggs.com',
                                                                      name: 'Joe Bloggs',
                                                                      first_name: @oauth_data[:first_name],
                                                                      last_name: @oauth_data[:last_name],
                                                                      image: 'http://graph.facebook.com/1234567/picture?type=square',
                                                                      urls: { facebook: 'http://www.facebook.com/jbloggs' },
                                                                      location: 'Palo Alto, California',
                                                                      verified: true
                                                                    },
                                                                    credentials: {
                                                                      token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
                                                                      expires_at: 1_321_747_205, # when the access token expires (it always will)
                                                                      expires: true # this will always be true
                                                                    },
                                                                    extra: {
                                                                      raw_info: {
                                                                        id: '1234567',
                                                                        name: "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
                                                                        first_name: @oauth_data[:first_name],
                                                                        last_name: @oauth_data[:last_name],
                                                                        link: 'http://www.facebook.com/jbloggs',
                                                                        username: 'jbloggs',
                                                                        location: { id: '123456789', name: 'Palo Alto, California' },
                                                                        gender: 'male',
                                                                        email: @oauth_data[:email],
                                                                        timezone: -8,
                                                                        locale: 'en_US',
                                                                        verified: true,
                                                                        updated_time: '2011-11-11T06:21:03+0000'
                                                                      }
                                                                    })
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    it 'permits to sign in creating a new user' do
      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t("devise.omniauth_callbacks.success")}/i)
      user_full_name = "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}"
      expect(page).to have_content(/#{user_full_name}/i)

      expect(User.count).to eq(1)
      user = User.last

      expect(user.user_type_id).to eq(UserType::AUTHENTICATED)
      expect(user.name).to eq(@oauth_data[:first_name])
      expect(user.surname).to eq(@oauth_data[:last_name])
      expect(user.email).to eq(@oauth_data[:email])
    end

    it "doesn't permit to sign in if FB account is not verified" do
      OmniAuth.config.mock_auth[:facebook][:info][:verified] = false
      OmniAuth.config.mock_auth[:facebook][:extra][:raw_info][:verified] = false
      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.account_not_verified', provider: @oauth_data[:provider].capitalize)}/i)
    end

    it 'asks for password reconfirmation to join an existing account with matching email' do
      user = create(:user, email: @oauth_data[:email])

      old_name = user.name
      old_surname = user.surname
      old_email = user.email

      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('users.confirm_credentials.title')}/i)

      # wrong password
      fill_in 'user_password', with: Faker::Internet.password
      click_button 'Join accounts and login'
      expect(page).to have_content(/#{I18n.t('error.users.join_accounts_password')}/i)

      # right password
      fill_in 'user_password', with: 'topolino'
      click_button 'Join accounts and login'
      expect(page).to have_content(/#{I18n.t('info.user.account_joined')}/i)

      user.reload
      expect(user.name).to eq(old_name)
      expect(user.surname).to eq(old_surname)
      expect(user.email).to eq(old_email)
    end

    it 'permits the join with an existing account when already logged in' do
      user = create(:user)
      login_as user, scope: :user

      old_name = user.name
      old_surname = user.surname
      old_email = user.email

      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      user.reload
      expect(user.name).to eq(old_name)
      expect(user.surname).to eq(old_surname)
      expect(user.email).to eq(old_email)
    end

    it "doesn't permit the join if FB account is already taken" do
      user = create(:user)
      login_as user, scope: :user
      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
      logout :user

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_failure', provider: @oauth_data[:provider].capitalize)}/i)
    end

    it 'remembers FB account after joining' do
      user = create(:user)
      login user, 'topolino'
      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
      logout :user

      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('devise.sessions.user.signed_in')}/i)
      expect(User.count).to eq(1)
    end

    it 'permits to detach FB account' do
      user = create(:user)
      authentication = create(:authentication, user: user)
      login_as user, scope: :user

      # visit '/users/auth/facebook/callback'
      # expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      visit privacy_preferences_users_path
      click_link 'Detach'
      expect(page).to have_content(/#{I18n.t('info.user.IP_disabled')}/i)

      logout :user
      # visit '/'

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/facebook/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
    end
  end
end
