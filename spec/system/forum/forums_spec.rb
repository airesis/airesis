require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'the management of the forum', retry: 3 do
  before do
    load_database
    @user = create(:user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
  end

  after do
    logout(:user)
  end

  it "can view groups fora (only public), can't view private fora if not logged in" do
    visit group_forums_path(@group)
    @group.forums.each do |forum|
      if forum.visible_outside
        expect(page).to have_content(forum.title)
      else
        expect(page).not_to have_content(forum.title)
      end
    end
  end

  it "can't view private fora of other groups if does not participate" do
    @user2 = create(:user)
    login_as @user2, scope: :user

    visit group_forums_path(@group)
    @group.forums.each do |forum|
      if forum.visible_outside
        expect(page).to have_content(forum.title)
      else
        expect(page).not_to have_content(forum.title)
      end
    end
  end

  it 'can view all fora in his group' do
    login_as @user, scope: :user
    visit group_forums_path(@group)
    @group.forums.each do |forum|
      expect(page).to have_content(forum.title)
    end
  end

  it 'can view all fora in group in which participate' do
    @user2 = create(:user)
    create_participation(@user2, @group)
    login_as @user2, scope: :user

    visit group_forums_path(@group)
    @group.forums.each do |forum|
      expect(page).to have_content(forum.title)
    end
  end

  # user created group1 and group2
  # user2 participate in group2
  # TODO: unauthorized access should not be tested in system test but request, so that ignore_js_errors can be removed
  it 'can create a new topic only in his group or in a group in which participate', :ignore_javascript_errors do
    @group2 = create(:group, current_user_id: @user.id)
    @user2 = create(:user)
    create_participation(@user2, @group2)
    @ability = Ability.new(@user2)

    visit new_group_forum_topic_path(@group, @group.forums.sample)
    expect_sign_in_page

    visit new_group_forum_topic_path(@group2, @group2.forums.sample)
    expect_sign_in_page

    visit new_group_forum_topic_path(@group, @group2.forums.sample)
    expect_sign_in_page

    login_as @user2, scope: :user

    forum = @group.forums.sample
    topic = forum.topics.build
    expect(@ability).not_to be_able_to(:create, topic)

    visit new_group_forum_topic_path(@group, forum)
    expect(page).to have_content(I18n.t('error.error_302.title'))

    forum = @group2.forums.sample
    topic = forum.topics.build

    expect(@ability).to be_able_to(:create, topic)

    visit new_group_forum_topic_path(@group2, forum)
    expect(page).to have_content(I18n.t('frm.topic.new'))

    visit new_group_forum_topic_path(@group, forum)
    expect(page).to have_content(I18n.t('error.error_302.title'))

    visit new_group_forum_topic_path(@group2, @group.forums.sample.id)
    expect(page).to have_content(I18n.t('error.error_404.title'))
  end

  # user created group1 and group2
  # user2 participate in group2
  it 'can create in group in which participate ' do
    @group2 = create(:group, current_user_id: @user.id)
    @user2 = create(:user)
    create_participation(@user2, @group2)
    @ability = Ability.new(@user2)

    login_as @user2, scope: :user

    forum = @group2.forums.sample
    topic = forum.topics.build
    expect(@ability).to be_able_to(:read, @group2)
    expect(@ability).to be_able_to(:read, forum)
    expect(@ability).to be_able_to(:new, topic)
    visit new_group_forum_topic_path(@group2, forum)
    expect(page).to have_content(I18n.t('frm.topic.new'))
  end
end
