require 'spec_helper'
require 'requests_helper'

describe 'the oauth2 process', type: :feature, js: true do

  describe 'Twitter' do

    before :each do
      @oauth_data = {
        provider: 'twitter',
        uid: Faker::Number.number(10),
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }

      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        provider: @oauth_data[:provider],
        uid: @oauth_data[:uid],
        info: {
          nickname: "johnqpublic",
          name: "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
          location: "Anytown, USA",
          image: "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
          description: "a very normal guy.",
          urls: {
            website: nil,
            twitter: "https://twitter.com/johnqpublic"
          }
        },
        credentials: {
          token: "a1b2c3d4...", # The OAuth 2.0 access token
          secret: "abcdef1234"
        },
        extra: {
          access_token: "", # An OAuth::AccessToken object
          raw_info: {
            name: "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
            listed_count: 0,
            profile_sidebar_border_color: "181A1E",
            url: nil,
            lang: "en",
            statuses_count: 129,
            profile_image_url: "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
            profile_background_image_url_https: "https://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif",
            location: "Anytown, USA",
            time_zone: "Chicago",
            follow_request_sent: false,
            id: 123456,
            profile_background_tile: true,
            profile_sidebar_fill_color: "666666",
            followers_count: 1,
            default_profile_image: false,
            screen_name: "",
            following: false,
            utc_offset: -3600,
            verified: false,
            favourites_count: 0,
            profile_background_color: "1A1B1F",
            is_translator: false,
            friends_count: 1,
            notifications: false,
            geo_enabled: true,
            profile_background_image_url: "http://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif",
            protected: false,
            description: "a very normal guy.",
            profile_link_color: "2FC2EF",
            created_at: "Thu Jul 4 00:00:00 +0000 2013",
            id_str: "123456",
            profile_image_url_https: "https://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
            default_profile: false,
            profile_use_background_image: false,
            entities: {
              description: {
                urls: []
              }
            },
            profile_text_color: "666666",
            contributors_enabled: false
          }
        }
      })

      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    end

    it 'permits to sign in creating a new user' do
      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t("devise.omniauth_callbacks.success")}/i)
      user_full_name = "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}"
      expect(page).to have_content(/#{user_full_name}/i)

      expect(User.count).to eq(1)
      user = User.last

      expect(user.user_type_id).to eq(UserType::AUTHENTICATED)
      expect(user.name).to eq(@oauth_data[:first_name])
      expect(user.surname).to eq(@oauth_data[:last_name])
    end

    it 'permits the join with an existing account when already logged in' do
      user = create(:user)
      login user, 'topolino'

      old_name = user.name
      old_surname = user.surname
      old_email = user.email

      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      user.reload
      expect(user.name).to eq(old_name)
      expect(user.surname).to eq(old_surname)
      expect(user.email).to eq(old_email)
    end

    it "doesn't permit the join if Twitter account is already taken" do
      user = create(:user)
      login user, 'topolino'
      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user
      visit '/'

      user2 = create(:user)
      login user2, 'topolino'
      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_failure', provider: @oauth_data[:provider].capitalize)}/i)
    end

    it "remembers Twitter account after joining" do
      user = create(:user)
      login user, 'topolino'
      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user
      visit '/'

      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t('devise.sessions.user.signed_in')}/i)
      expect(User.count).to eq(1)
    end

    it 'permits to detach Twitter account' do
      user = create(:user)
      login user, 'topolino'

      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      visit privacy_preferences_users_path
      click_link 'Detach'
      expect(page).to have_content(/#{I18n.t('info.user.IP_disabled')}/i)

      logout :user
      visit '/'

      user2 = create(:user)
      login user2, 'topolino'
      visit '/users/auth/twitter/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
    end
  end

end

