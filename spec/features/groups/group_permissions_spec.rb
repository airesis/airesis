require 'rails_helper'
require 'requests_helper'

describe 'check permissions are actually working inside groups', type: :feature do
  before :each do
    load_database
    @user = create(:user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
  end

  after :each do
    logout(:user)
  end

  it 'sets correctly the permissions when the group is created' do
    # the permission to view proposals is given by default to every user

    group1_users = []
    10.times do
      user = create(:user)
      create_participation(user, @group)
      group1_users << user
    end

    # one of participants is also administrator of another group
    @user2 = create(:user)
    @group2 = create(:group, current_user_id: @user2.id)
    create_participation(@user2, @group)
    # people ing group2 can support proposals by default
    @group2.default_role.update(support_proposals: true)
    group1_users.sample(5).each do |user|
      create_participation(user, @group2)
    end

    all = 12
    expect(@group.scoped_participants(:write_to_wall).count).to eq all
    expect(@group.scoped_participants(:create_events).count).to eq all
    expect(@group.scoped_participants(:support_proposals).count).to eq 1
    expect(@group.scoped_participants(:accept_participation_requests).count).to eq 1
    expect(@group.scoped_participants(:view_proposals).count).to eq all
    expect(@group.scoped_participants(:participate_proposals).count).to eq all
    expect(@group.scoped_participants(:insert_proposals).count).to eq all
    expect(@group.scoped_participants(:view_documents).count).to eq all
    expect(@group.scoped_participants(:manage_documents).count).to eq 1
    expect(@group.scoped_participants(:vote_proposals).count).to eq all
    expect(@group.scoped_participants(:choose_date_proposals).count).to eq all

    doc_manager = create(:participation_role, group: @group, manage_documents: true)
  end

  it 'you can see your permissions in the group', js: true do
    user = create(:user)
    create_participation(user, @group)
    login_as user, scope: :user

    visit group_path(@group)
    within_left_menu do
      click_link I18n.t('pages.groups.show.list_permissions.button')
    end
    expect(page).to have_content I18n.t('pages.users.show.what_can_i_do')
  end
end
