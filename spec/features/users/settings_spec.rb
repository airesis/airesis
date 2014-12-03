require 'spec_helper'
require 'requests_helper'

describe "personal settings", type: :feature, js: true do

  let!(:user) {create(:user)}

  before :each do
    login_as user, scope: :user
  end

  after :each do
    logout(:user)
  end

  it "can change name" do
    visit user_path(user)
    expect(page).to have_content(I18n.t('info.user.click_to_change'))
    find('#name_profile').click
    new_name = Faker::Name.first_name
    within '#name_modal' do
      find(:css, '#user_name').set new_name
      click_button I18n.t('buttons.save')
    end
    expect(page).to have_content(I18n.t('info.user.info_updated'))
    user.reload
    expect(user.name).to eq new_name
  end


  it "can change last name" do
    visit user_path(user)
    expect(page).to have_content(I18n.t('info.user.click_to_change'))
    find('#surname_profile').click
    new_name = Faker::Name.last_name
    within '#surname_modal' do
      find(:css, '#user_surname').set new_name
      click_button I18n.t('buttons.save')
    end
    expect(page).to have_content(I18n.t('info.user.info_updated'))
    user.reload
    expect(user.surname).to eq new_name
  end

  it "can enable/disable tooltips" do
    visit privacy_preferences_users_path
    find('#user_show_tooltips').click
    expect(page).to have_content(I18n.t('info.user.tooltips_disabled'))
    user.reload
    expect(user.show_tooltips).to be_falsey

    visit privacy_preferences_users_path
    find('#user_show_tooltips').click
    expect(page).to have_content(I18n.t('info.user.tooltips_enabled'))
    user.reload
    expect(user.show_tooltips).to be_truthy
  end

  it "can show/hide social netwrok urls" do
    visit privacy_preferences_users_path
    find('#user_show_urls').click
    expect(page).to have_content(I18n.t('info.user.url_hidden'))
    user.reload
    expect(user.show_urls).to be_falsey

    visit privacy_preferences_users_path
    find('#user_show_urls').click
    expect(page).to have_content(I18n.t('info.user.url_shown'))
    user.reload
    expect(user.show_urls).to be_truthy
  end

  it "can enable/disable messages" do
    visit privacy_preferences_users_path
    find('#user_receive_messages').click
    expect(page).to have_content(I18n.t('info.private_messages_inactive'))
    user.reload
    expect(user.receive_messages).to be_falsey

    visit privacy_preferences_users_path
    find('#user_receive_messages').click
    expect(page).to have_content(I18n.t('info.private_messages_active'))
    user.reload
    expect(user.receive_messages).to be_truthy
  end
end
