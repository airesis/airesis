require 'spec_helper'
require 'requests_helper'

describe "the user can invite other participants in the group", type: :feature, js: true do

  let!(:user) { create(:default_user) }
  let!(:group) { create(:group, current_user_id: user.id) }
  let!(:ability) { Ability.new(user) }

  after :each do
    logout(:user)
  end

  it "can send inviations to an email address and a non-registered user can accept the invite" do
    login_as user, scope: :user
    visit group_path(group)
    within_left_menu do
      click_link I18n.t('pages.groups.show.invite_button')
    end
    emails = [Faker::Internet.email, Faker::Internet.email, Faker::Internet.email]
    within '#invitation_container' do
      fill_tokeninput '#group_invitation_emails_list', with: emails
      fill_in I18n.t('activerecord.attributes.group_invitation.testo'), with: Faker::Lorem.paragraph
      click_button I18n.t('buttons.send')
    end
    expect(page).to have_content I18n.t('info.group_invitations.create')
    expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq 3
    Sidekiq::Extensions::DelayedMailer.drain
    first_deliveries = ActionMailer::Base.deliveries.first(3)
    expect(first_deliveries.map { |m| m.to[0] }).to match_array emails
    logout :user

    group_invitation = GroupInvitation.last
    visit accept_group_invitations_path(group_id: group.id, token: group_invitation.token, email: group_invitation.group_invitation_email.email)
    expect(page.current_path).to eq new_user_registration_path
    fill_in I18n.t('pages.registration.choose_password'), with: 'topolino'
    fill_in I18n.t('pages.registration.confirm_password'), with: 'topolino'
    fill_in I18n.t('activerecord.attributes.user.name'), with: Faker::Name.first_name
    fill_in I18n.t('activerecord.attributes.user.surname'), with: Faker::Name.last_name
    check I18n.t('pages.registration.accept_conditions')
    check I18n.t('pages.registration.accept_privacy')
    click_button I18n.t('pages.registration.register_button')
    expect(page.current_path).to eq group_path(group)
    expect(page).to have_content(I18n.t('info.group_invitations.accept'))
  end
end
