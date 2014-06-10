require 'spec_helper'
require 'requests_helper'

describe "the authenticated user process", type: :feature, js: true do
  before :all do
    @user = create(:default_user)
  end

  before :each do
    login @user, 'topolino'
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
    @user = create(:second_user)
    login @user, 'topolino'
    visit '/home'
    expect(page).to have_content(I18n.t('pages.home.show.your_proposals'))
    expect(page).to have_content(I18n.t('pages.home.show.proposals_now_voting'))
    visit user_path(@user)
  end
end