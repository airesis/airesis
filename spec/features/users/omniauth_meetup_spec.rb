require 'spec_helper'
require 'requests_helper'

describe 'the oauth2 process', type: :feature, js: true do
  describe 'Meetup' do
    before :each do
      @oauth_data = {
        provider: 'meetup',
        uid: Faker::Number.number(10),
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }

      OmniAuth.config.mock_auth[:meetup] = OmniAuth::AuthHash.new('provider' => @oauth_data[:provider],
                                                                  'uid' => @oauth_data[:uid],
                                                                  'info' => {
                                                                    'id' => 0,
                                                                    'name' => "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
                                                                    'photo_url' => 'http://photos3.meetupstatic.com/photos/member_pic_0.jpeg'
                                                                  },
                                                                  'credentials' => {
                                                                    'token' => 'abc123...',         # OAuth 2.0 access_token, which you may wish to store
                                                                    'refresh_token' => 'bcd234...', # This token can be used to refresh your access_token later
                                                                    'expires_at' => 1_324_720_198,     # when the access token expires (Meetup tokens expire in 1 hour)
                                                                    'expires' => true
                                                                  },
                                                                  'extra' => {
                                                                    'raw_info' => {
                                                                      'lon' => -90.027181,
                                                                      'link' => 'http://www.meetup.com/members/0',
                                                                      'lang' => 'en_US',
                                                                      'photo' => {
                                                                        'photo_link' =>  'http://photos3.meetupstatic.com/photos/member_pic_0.jpeg',
                                                                        'highres_link' =>  'http://photos1.meetupstatic.com/photos/member_pic_0_hires.jpeg',
                                                                        'thumb_link' =>  'http://photos1.meetupstatic.com/photos/member_pic_0_thumb.jpeg',
                                                                        'photo_id' => 0
                                                                      },
                                                                      'city' => 'Memphis',
                                                                      'country' => 'us',
                                                                      'visited' => 1_325_001_005_000,
                                                                      'id' => 0,
                                                                      'topics' => [],
                                                                      'joined' => 1_147_652_858_000,
                                                                      'name' => "#{@oauth_data[:first_name]} #{@oauth_data[:last_name]}",
                                                                      'other_services' => { 'twitter' => { 'identifier' => '@elvis' } },
                                                                      'lat' => 35.046677
                                                                    }
                                                                  })

      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:meetup]
    end

    it 'permits to sign in creating a new user' do
      visit '/users/auth/meetup/callback'
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

      visit '/users/auth/meetup/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      user.reload
      expect(user.name).to eq(old_name)
      expect(user.surname).to eq(old_surname)
      expect(user.email).to eq(old_email)
    end

    it "doesn't permit the join if Meetup account is already taken" do
      user = create(:user)
      login_as user, scope: :user
      visit '/users/auth/meetup/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user
      visit '/'

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/meetup/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_failure', provider: @oauth_data[:provider].capitalize)}/i)
    end

    it 'remembers Meetup account after joining' do
      user = create(:user)
      login_as user, scope: :user
      visit '/users/auth/meetup/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)

      logout :user
      visit '/'

      visit '/users/auth/meetup/callback'
      expect(page).to have_content(/#{I18n.t('devise.sessions.user.signed_in')}/i)
      expect(User.count).to eq(1)
    end

    it 'permits to detach Meetup account' do
      user = create(:user)
      create(:authentication, user: user, provider: 'meetup')
      login_as user, scope: :user

      visit privacy_preferences_users_path
      click_link 'Detach'
      expect(page).to have_content(/#{I18n.t('info.user.IP_disabled')}/i)

      logout :user

      user2 = create(:user)
      login_as user2, scope: :user
      visit '/users/auth/meetup/callback'
      expect(page).to have_content(/#{I18n.t('devise.omniauth_callbacks.join_success', provider: @oauth_data[:provider].capitalize)}/i)
    end
  end
end
