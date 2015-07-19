require 'spec_helper'
require 'requests_helper'

describe 'the oauth2 process', type: :feature, js: true do

  describe 'Linkedin' do

    before :each do

      @oauth_data = {
        provider: 'linkedin',
        uid: Faker::Number.number(10),
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }

      OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
        "provider" => @oauth_data[:provider],
        "uid" => @oauth_data[:uid],
        "info" => {
          "name" => "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
          "email" => @oauth_data[:email],
          "nickname" => "John Doe",
          "first_name" => @oauth_data[:first_name],
          "last_name" => @oauth_data[:last_name],
          "location" => "Greater Boston Area, US",
          "description" => "Senior Developer, Hammertech",
          "image" =>  "http://m.c.lnkd.licdn.com/mpr/mprx/0_aBcD...",
          "phone" => "null",
          "headline" =>  "Senior Developer, Hammertech",
          "industry" => "Internet",
          "urls" => {
            "public_profile" => "http://www.linkedin.com/in/johndoe"
          }
        },
        "credentials" =>  {
          "token" => "12312...",
          "secret" => "aBc..."
        },
        "extra" => 
        {
          "access_token" =>  {
            "token" => "12312...",
            "secret" => "aBc...",
            "consumer" => nil, #<OAuth::Consumer>
            "params" =>  {
              :oauth_token => "12312...",
              :oauth_token_secret => "aBc...",
              :oauth_expires_in => "5183999",
              :oauth_authorization_expires_in => "5183999",
            },
            "response" => nil #<Net::HTTPResponse>
          },
         "raw_info" =>  {
           "firstName" => @oauth_data[:first_name],
           "headline" => "Senior Developer, Hammertech",
           "id" => "AbC123",
           "industry" => "Internet",
           "lastName" => @oauth_data[:last_name],
           "location" =>  {"country" => {"code" => "us"}, "name" => "Greater Boston Area"},
           "pictureUrl" =>  "http://m.c.lnkd.licdn.com/mpr/mprx/0_aBcD...",
           "publicProfileUrl" => "http://www.linkedin.com/in/johndoe"
          }
        }
      })

      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:linkedin]
    end

    it 'permits to sign in creating a new user' do
      visit '/users/auth/linkedin/callback'
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

    it 'permits the join with an existing account when already logged in' do
      user = create(:user)
      login_as user, scope: :user

      old_name = user.name
      old_surname = user.surname
      old_email = user.email

      visit '/users/auth/linkedin/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      user.reload
      expect(user.name).to eq(old_name)
      expect(user.surname).to eq(old_surname)
      expect(user.email).to eq(old_email)
    end

    it "doesn't permit the join if Linkedin account is already taken" do
      user = create(:user)
      login_as user, scope: :user
      visit '/users/auth/linkedin/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/linkedin/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_failure', provider: @oauth_data[:provider].capitalize)}/i)
    end

    it "remembers Linkedin account after joining" do
      user = create(:user)
      login_as user, scope: :user
      visit '/users/auth/linkedin/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user

      visit '/users/auth/linkedin/callback'
      expect(page).to have_content(/#{I18n.t('devise.sessions.user.signed_in')}/i)
      expect(User.count).to eq(1)
    end

    it 'permits to detach Linkedin account' do
      user = create(:user)
      create(:authentication, user: user, provider: 'linkedin')
      login_as user, scope: :user

      visit privacy_preferences_users_path
      click_link 'Detach'
      expect(page).to have_content(/#{I18n.t('info.user.IP_disabled')}/i)

      logout :user

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/linkedin/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
    end
  end
end
