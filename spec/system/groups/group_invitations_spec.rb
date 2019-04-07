require 'rails_helper'
require 'requests_helper'

describe 'the user can invite other participants in the group', :js do
  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:ability) { Ability.new(user) }

  let(:acceptor) { create(:user) }
  let(:emails) { [Faker::Internet.email, Faker::Internet.email, acceptor.email] }
  let(:group_invitation) { create(:group_invitation, group: group, emails_list: emails.join(','), inviter_id: user.id) }

  before do
    load_database
  end

  after do
    logout(:user)
  end

  describe 'non registered user reply to invitation' do
    def fill_in_registration_form
      fill_in I18n.t('pages.registration.choose_password'), with: 'topolino'
      fill_in I18n.t('pages.registration.confirm_password'), with: 'topolino'
      fill_in I18n.t('activerecord.attributes.user.name'), with: Faker::Name.first_name
      fill_in I18n.t('activerecord.attributes.user.surname'), with: Faker::Name.last_name
      check I18n.t('pages.registration.accept_conditions')
      check I18n.t('pages.registration.accept_privacy')
      click_button I18n.t('pages.registration.register_button')
      sleep 2
    end

    it 'can send inviations to an email address and can accept the invite' do
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
      expect(page).to have_content I18n.t('info.group_invitations.create', count: 3, email_addresses: emails.join(', '))
      expect(ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.jobs.size).to eq 3
      ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.drain
      first_deliveries = ActionMailer::Base.deliveries.first(3)
      expect(first_deliveries.map { |m| m.to[0] }).to match_array emails
      logout :user

      group_invitation_email = GroupInvitationEmail.last
      visit accept_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path new_user_registration_path(invite: group_invitation_email.token)
      fill_in_registration_form

      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.accept'))
    end

    it 'can reject the invite' do
      emails = [Faker::Internet.email, Faker::Internet.email, Faker::Internet.email]
      create(:group_invitation, group: group, emails_list: emails.join(','), inviter_id: user.id)
      expect(ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.jobs.size).to eq 3
      ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.drain
      first_deliveries = ActionMailer::Base.deliveries.first(3)
      expect(first_deliveries.map { |m| m.to[0] }).to match_array emails

      group_invitation_email = GroupInvitationEmail.last
      visit reject_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.reject'))
    end

    it 'can anymore the invite' do
      emails = [Faker::Internet.email, Faker::Internet.email, Faker::Internet.email]
      create(:group_invitation, group: group, emails_list: emails.join(','), inviter_id: user.id)

      group_invitation_email = GroupInvitationEmail.last
      visit anymore_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.anymore'))
      expect(BannedEmail.last.email).to eq group_invitation_email.email
    end
  end

  describe 'a registered user reply but not logged in' do
    def fill_in_login_form
      fill_in I18n.t('activerecord.attributes.user.password'), with: 'topolino'
      click_button I18n.t('buttons.login')
    end

    it 'can accept the invite' do
      group_invitation_email = group_invitation.group_invitation_emails.find_by(email: acceptor.email)
      visit accept_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path new_user_session_path(invite: group_invitation_email.token, user: { email: group_invitation_email.email })
      fill_in_login_form
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.accept'))
    end

    it 'can reject the invite' do
      group_invitation_email = group_invitation.group_invitation_emails.find_by(email: acceptor.email)
      visit reject_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.reject'))
    end

    it 'can anymore the invite' do
      group_invitation_email = group_invitation.group_invitation_emails.find_by(email: acceptor.email)
      visit anymore_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.anymore'))
      expect(BannedEmail.last.email).to eq group_invitation_email.email
    end
  end

  describe 'a registered user reply but logged in' do
    before do
      login_as acceptor, scope: :user
    end

    it 'can accept the invite' do
      group_invitation_email = group_invitation.group_invitation_emails.find_by(email: acceptor.email)
      visit accept_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.accept'))
    end

    it 'can reject the invite' do
      group_invitation_email = group_invitation.group_invitation_emails.find_by(email: acceptor.email)
      visit reject_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.reject'))
    end

    it 'can anymore the invite' do
      group_invitation_email = group_invitation.group_invitation_emails.find_by(email: acceptor.email)
      visit anymore_group_group_invitation_group_invitation_email_path(group, group_invitation_email.group_invitation, group_invitation_email.token, email: group_invitation_email.email)
      expect(page).to have_current_path group_path(group)
      expect(page).to have_content(I18n.t('info.group_invitations.anymore'))
      expect(BannedEmail.last.email).to eq group_invitation_email.email
    end
  end
end
