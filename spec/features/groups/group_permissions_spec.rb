require 'spec_helper'
require 'requests_helper'

describe "check permissions are actually working inside groups", type: :feature do
  before :each do
    @user = create(:user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
  end

  after :each do
    logout(:user)
  end

  it "sets correctly the permissions when the group is created" do
    #the permission to view proposals is given by default to every user

    group1_users = []
    10.times do
      user = create(:user)
      create_participation(user, @group)
      group1_users << user
    end

    #one of participants is also administrator of another group
    @user2 = create(:user)
    @group2 = create(:group, current_user_id: @user2.id)
    create_participation(@user2, @group)
    #people ing group2 can support proposals by default
    @group2.default_role.action_abilitations.create(group_action_id: GroupAction::SUPPORT_PROPOSAL, group_id: @group2.id)
    group1_users.sample(5).each do |user|
      create_participation(user, @group2)
    end

    all = 12
    expect(@group.scoped_participants(GroupAction::STREAM_POST).count).to eq all
    expect(@group.scoped_participants(GroupAction::CREATE_EVENT).count).to eq all
    expect(@group.scoped_participants(GroupAction:: SUPPORT_PROPOSAL).count).to eq 1
    expect(@group.scoped_participants(GroupAction:: REQUEST_ACCEPT).count).to eq 1
    expect(@group.scoped_participants(GroupAction::PROPOSAL_VIEW).count).to eq all
    expect(@group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count).to eq all
    expect(@group.scoped_participants(GroupAction::PROPOSAL_INSERT).count).to eq all
    expect(@group.scoped_participants(GroupAction:: DOCUMENTS_VIEW).count).to eq all
    expect(@group.scoped_participants(GroupAction:: DOCUMENTS_MANAGE).count).to eq 1
    expect(@group.scoped_participants(GroupAction::PROPOSAL_VOTE).count).to eq all
    expect(@group.scoped_participants(GroupAction::PROPOSAL_DATE).count).to eq all

    doc_manager = create(:participation_role, group: @group)
    doc_manager.action_abilitations.create(group_action_id: GroupAction::DOCUMENTS_MANAGE, group_id: @group.id)
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
