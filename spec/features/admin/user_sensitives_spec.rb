require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe 'the management of user sensitives', type: :feature, js: true do
  let!(:admin) { create(:admin) }
  let(:user_sensitives) { create_list(:user_sensitive, 5) }
  let(:user_sensitive) { create(:user_sensitive) }

  before :each do
    login_as admin, scope: :user
  end

  after :each do
    logout :user
  end

  it 'can list user_sensitives' do
    user_sensitives
    visit admin_user_sensitives_path
    user_sensitives.each do |user_sensitive|
      expect(page).to have_content(user_sensitive.surname)
    end
  end

  it 'can edit user_sensitives' do
    user_sensitive
    visit edit_admin_user_sensitive_path(user_sensitive)
    new_name = Faker::Name.name
    fill_in I18n.t('activerecord.attributes.user_sensitive.name'), with: new_name
    click_button 'Update User sensitive'
    expect(page).to have_content I18n.t('info.user_sensitive.updated')
    expect(page).to have_content new_name
  end
end
