require 'spec_helper'
require 'requests_helper'

describe "the authenticated user process", type: :feature, js: true do
  before :each do
    @user = User.new(:email => 'user@example.com', :password => 'caplin', password_confirmation: 'caplin', name: 'Test', surname: 'Tested')
    @user.user_type_id = UserType::AUTHENTICATED
    @user.skip_confirmation!
    #@user.admin = true
    @user.save!
    login @user, 'caplin'
    #login_as @user, scope: :user
  end

  after :each do
    logout(:user)
  end

  it "signs in the user correctly" do
    visit '/home'
    expect(page).to have_content(I18n.t('pages.home.show.your_proposals'))
    expect(page).to have_content(I18n.t('pages.home.show.proposals_now_voting'))
  end


  it "signs in one user, logout, sign in another" do
    visit '/home'
    expect(page).to have_content(I18n.t('pages.home.show.your_proposals'))
    expect(page).to have_content(I18n.t('pages.home.show.proposals_now_voting'))

    logout(:user)

    visit '/'
    @user = User.new(:email => 'second@example.com', :password => 'cappell', password_confirmation: 'cappell', name: 'Secondo', surname: 'Utente')
    @user.user_type_id = UserType::AUTHENTICATED
    @user.skip_confirmation!
    #@user.admin = true
    @user.save!
    login @user, 'cappell'
    visit '/home'
    expect(page).to have_content(I18n.t('pages.home.show.your_proposals'))
    expect(page).to have_content(I18n.t('pages.home.show.proposals_now_voting'))
    visit user_path(@user)

  end
end