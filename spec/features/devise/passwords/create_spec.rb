require 'spec_helper'

describe 'devise/passwords#create', type: :feature, js: true do
  let!(:user) {create(:user)}

  it 'can retrieve his password correctly' do
    visit new_user_password_path
    fill_in I18n.t('activerecord.attributes.user.email'), with: user.email
    click_button I18n.t('pages.password.submit')
    expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
  end

  it 'checks the email case insensitive' do
    visit new_user_password_path
    fill_in I18n.t('activerecord.attributes.user.email'), with: user.email.upcase
    click_button I18n.t('pages.password.submit')
    expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
  end

  it "can't retrieve password if blocked" do
    user.update_columns(blocked: true) # TODO: move block method in user class
    visit new_user_password_path
    fill_in I18n.t('activerecord.attributes.user.email'), with: user.email.upcase
    click_button I18n.t('pages.password.submit')
    expect(page).not_to have_content(I18n.t('devise.passwords.send_instructions'))
  end
end
