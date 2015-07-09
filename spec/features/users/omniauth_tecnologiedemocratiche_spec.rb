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
        last_name: Faker::Name.last_name,
        tax_code: 'XXXXXXXXXXXXXXXX'
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
          last_name: @oauth_data[:last_name],
          tax_code: @oauth_data[:tax_code]
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
      user = User.last

      expect(user.user_type_id).to eq(UserType::CERTIFIED)
      expect(user.name).to eq(@oauth_data[:first_name])
      expect(user.surname).to eq(@oauth_data[:last_name])
      expect(user.email).to eq(@oauth_data[:email])
    end

    it 'asks for password reconfirmation to join an existing account with matching email' do
      user = create(:user, email: @oauth_data[:email])
      visit '/users/auth/tecnologiedemocratiche/callback'
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
      expect(user.user_type_id).to eq(UserType::CERTIFIED)
      expect(user.name).to eq(@oauth_data[:first_name])
      expect(user.surname).to eq(@oauth_data[:last_name])
      expect(user.email).to eq(@oauth_data[:email])
      expect(user.certification).to be_present
    end

    it 'permits the join with an existing account when already logged in' do
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

    it 'does not permit to proceed with the join if TD email is already taken' do
      airesis_user = create(:user, email: @oauth_data[:email])

      user = create(:user)
      initial_data = { email: user.email, first_name: user.name, last_name: user.surname }
      login user, 'topolino'

      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.certified_email_taken')}/i)

      user.reload
      expect(user.user_type_id).to eq(UserType::AUTHENTICATED)
      expect(user.name).to eq(initial_data[:first_name])
      expect(user.surname).to eq(initial_data[:last_name])
      expect(user.email).to eq(initial_data[:email])
    end

    it 'permits to proceed with the join if TD email is already taken by the current user' do
      user = create(:user, email: @oauth_data[:email])
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

    it 'does not permit to join TD account if the user has another certified account' do
      certified_account = create(:user)
      UserSensitive.create!(user: certified_account, name: @oauth_data[:first_name], surname: @oauth_data[:last_name], tax_code: @oauth_data[:tax_code])

      user = create(:user)
      initial_data = { email: user.email, first_name: user.name, last_name: user.surname }
      login user, 'topolino'

      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.already_certified')}/i)

      user.reload
      expect(user.user_type_id).to eq(UserType::AUTHENTICATED)
      expect(user.name).to eq(initial_data[:first_name])
      expect(user.surname).to eq(initial_data[:last_name])
      expect(user.email).to eq(initial_data[:email])
    end

    it 'does not permit to sign in with TD if that user has another certified account' do
      certified_account = create(:user)
      UserSensitive.create!(user: certified_account, name: @oauth_data[:first_name], surname: @oauth_data[:last_name], tax_code: @oauth_data[:tax_code])

      visit '/users/auth/tecnologiedemocratiche/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.already_certified')}/i)
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
