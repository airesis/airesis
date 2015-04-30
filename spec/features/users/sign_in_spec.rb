require 'spec_helper'
require 'requests_helper'

describe "the authenticated user process", type: :feature, js: true do
  before :each do
    @user = create(:user)
    login @user, 'topolino'
    #login_as @user, scope: :user
  end

  after :each do
    logout(:user)
  end

  it "signs in the user correctly" do
    visit '/home'
    expect(page).to have_content(/#{I18n.t('pages.home.show.your_proposals')}/i)
    expect(page).to have_content(/#{I18n.t('pages.home.show.proposals_now_voting')}/i)
  end


  it "signs in one user, logout, sign in another" do
    visit '/home'
    expect(page).to have_content(/#{I18n.t('pages.home.show.your_proposals')}/i)
    expect(page).to have_content(/#{I18n.t('pages.home.show.proposals_now_voting')}/i)

    logout(:user)

    visit '/'
    @user = create(:user)
    login @user, 'topolino'
    visit '/home'
    expect(page).to have_content(/#{I18n.t('pages.home.show.your_proposals')}/i)
    expect(page).to have_content(/#{I18n.t('pages.home.show.proposals_now_voting')}/i)
    visit user_path(@user)
  end
end
