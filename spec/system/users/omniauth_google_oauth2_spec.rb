require 'rails_helper'
require 'requests_helper'

describe 'the oauth2 process', :js do
  describe 'Google oauth2' do
    before do
      @oauth_data = {
        provider: 'google_oauth2',
        uid: Faker::Number.number(digits: 10),
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }

      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(provider: @oauth_data[:provider],
                                                                         uid: @oauth_data[:uid],
                                                                         info: {
                                                                           name: "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
                                                                           email: @oauth_data[:email],
                                                                           first_name: @oauth_data[:first_name],
                                                                           last_name: @oauth_data[:last_name],
                                                                           image: 'https://lh3.googleusercontent.com/url/photo.jpg'
                                                                         },
                                                                         credentials: {
                                                                           token: 'token',
                                                                           refresh_token: 'another_token',
                                                                           expires_at: 1_354_920_555,
                                                                           expires: true
                                                                         },
                                                                         extra: {
                                                                           raw_info: {
                                                                             sub: '123456789',
                                                                             email: @oauth_data[:email],
                                                                             email_verified: true,
                                                                             name: "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
                                                                             given_name: @oauth_data[:first_name],
                                                                             family_name: @oauth_data[:last_name],
                                                                             profile: 'https://plus.google.com/123456789',
                                                                             picture: 'https://lh3.googleusercontent.com/url/photo.jpg',
                                                                             gender: 'male',
                                                                             birthday: '0000-06-25',
                                                                             locale: 'en',
                                                                             hd: 'company_name.com'
                                                                           },
                                                                           id_info: {
                                                                             'iss' => 'accounts.google.com',
                                                                             'at_hash' => 'HK6E_P6Dh8Y93mRNtsDB1Q',
                                                                             'email_verified' => 'true',
                                                                             'sub' => '10769150350006150715113082367',
                                                                             'azp' => 'APP_ID',
                                                                             'email' => 'jsmith@example.com',
                                                                             'aud' => 'APP_ID',
                                                                             'iat' => 1_353_601_026,
                                                                             'exp' => 1_353_604_926,
                                                                             'openid_id' => 'https://www.google.com/accounts/o8/id?id=ABCdfdswawerSDFDsfdsfdfjdsf'
                                                                           }
                                                                         })
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    it 'permits to sign in creating a new user' do
      visit '/users/auth/google_oauth2/callback'
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

    it 'asks for password reconfirmation to join an existing account with matching email' do
      user = create(:user, email: @oauth_data[:email])

      old_name = user.name
      old_surname = user.surname
      old_email = user.email

      visit '/users/auth/google_oauth2/callback'
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

      visit '/users/auth/google_oauth2/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      user.reload
      expect(user.name).to eq(old_name)
      expect(user.surname).to eq(old_surname)
      expect(user.email).to eq(old_email)
    end

    it "doesn't permit the join if Google account is already taken" do
      user = create(:user)
      login_as user, scope: :user
      visit '/users/auth/google_oauth2/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/google_oauth2/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_failure', provider: @oauth_data[:provider].capitalize)}/i)
    end

    it 'remembers Google account after joining' do
      user = create(:user)
      login_as user, scope: :user
      visit '/users/auth/google_oauth2/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user

      visit '/users/auth/google_oauth2/callback'
      expect(page).to have_content(/#{I18n.t('devise.sessions.user.signed_in')}/i)
      expect(User.count).to eq(1)
    end

    it 'permits to detach Google account' do
      user = create(:user)
      create(:authentication, user: user, provider: 'google_oauth2')
      login_as user, scope: :user

      visit privacy_preferences_users_path
      click_link 'Detach'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content(/#{I18n.t('info.user.IP_disabled')}/i)

      logout :user

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/google_oauth2/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
    end
  end
end
