require 'rails_helper'
require 'requests_helper'

describe 'the authenticated user process', :js do
  before do
    @user = create(:user)
    login @user, 'topolino'
  end

  after do
    logout(:user)
  end

  it 'signs in the user correctly' do
    expect(page).to have_content(/#{I18n.t('pages.home.show.your_proposals')}/i)
    expect(page).to have_content(/#{I18n.t('pages.home.show.proposals_now_voting')}/i)
  end

  it 'signs in one user, logout, sign in another' do
    expect(page).to have_content(/#{I18n.t('pages.home.show.your_proposals')}/i)
    expect(page).to have_content(/#{I18n.t('pages.home.show.proposals_now_voting')}/i)

    logout(:user)

    visit '/'
    @user = create(:user)
    login @user, 'topolino'
    expect(page).to have_content(/#{I18n.t('pages.home.show.your_proposals')}/i)
    expect(page).to have_content(/#{I18n.t('pages.home.show.proposals_now_voting')}/i)
    visit user_path(@user)
  end
end
