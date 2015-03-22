require 'spec_helper'
require 'requests_helper'

describe 'topics', type: :feature, js: true do

  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }
  let!(:free_category) { create(:frm_category, group: group, visible_outside: true) }
  let!(:forum) { create(:frm_forum, group: group, category: free_category) }
  let!(:topic) { create(:approved_topic, forum: forum, user: user) }
  let!(:other_user) { create(:user) }
  let!(:other_topic) { create(:approved_topic, subject: Faker::Lorem.sentence, user: other_user, forum: forum) }

  context 'not signed in' do
    it 'cannot create a new topic' do
      visit new_group_forum_topic_path(group, forum)
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'signed in' do
    before do
      login_as user, scope: :user
      visit new_group_forum_topic_path(group, forum)
    end

    context 'creating a topic' do

      it 'is valid with subject and post text' do
        topic_name = Faker::Lorem.sentence
        post_content = Faker::Lorem.paragraph
        fill_in I18n.t('simple_form.labels.topic.subject'), with: topic_name
        fill_in_ckeditor 'frm_topic_posts_attributes_0_text', with: post_content
        click_button I18n.t('helpers.submit.topic.create')

        expect(page).to have_content(I18n.t('frm.topic.created'))
        expect(page).to have_content(topic_name)
        expect(page).to have_content(post_content)
        expect(page).to have_content(user.fullname)

        visit root_path
        expect(page).to_not have_content(I18n.t('frm.topic.created'))
      end

      it 'can delete their own topics' do
        visit group_forum_topic_path(group, forum, topic)
        within_left_menu do
          click_link(I18n.t('buttons.delete'))
        end
        expect_message I18n.t('frm.topic.deleted')
      end

      it 'can subscribe to a topic' do
        visit group_forum_topic_path(group, forum, other_topic)
        within_left_menu do
          click_link(I18n.t('frm.topics.show.subscribe'))
        end
        expect_message I18n.t('frm.topic.subscribed')
        expect(page).to have_content(I18n.t('frm.topics.show.unsubscribe'))
      end

      it 'can unsubscribe from an subscribed topic' do
        other_topic.subscribe_user(user.id)
        visit group_forum_topic_path(group, forum, other_topic)
        within_left_menu do
          click_link I18n.t('frm.topics.show.unsubscribe')
        end
        expect_message I18n.t('frm.topic.unsubscribed')
        expect(page).to have_content(I18n.t('frm.topics.show.subscribe'))
      end

      it 'cannot delete topics by others' do
        logout user
        login_as other_user, scope: :user
        visit group_forum_topic_path(group, forum, topic)
        within_left_menu do
          expect(page).to_not have_selector('a', text: I18n.t('buttons.delete'))
        end
      end

      it 'can delete topics by others if an admin of the group' do
        topic.user = create(:user) # Assign alternate user
        topic.save

        visit group_forum_topic_path(group, forum, topic)
        within_left_menu do
          click_link(I18n.t('buttons.delete'))
        end
        expect_message I18n.t('frm.topic.deleted')
      end

      context 'creating a topic' do
        it 'creates a view' do
          visit group_forum_topic_path(group, forum, topic)
          expect(Frm::View.count).to eq 1
        end

        it 'increments a view' do
          # register a view
          visit group_forum_topic_path(group, forum, topic)

          view = ::Frm::View.last
          expect(view.count).to eql(1)
          visit group_forum_topic_path(group, forum, topic)
          view.reload
          expect(view.count).to eql(2)
        end
      end
    end

    context 'updating a topic' do
      it 'can update successfully' do
        visit group_forum_topic_path(group, forum, other_topic)
        within_left_menu do
          click_link(I18n.t('frm.topic.links.edit'))
        end
        topic_name = Faker::Lorem.sentence

        fill_in I18n.t('simple_form.labels.topic.subject'), with: topic_name

        click_button I18n.t('helpers.submit.topic.update')

        expect(page).to have_content(I18n.t('frm.topic.updated'))
        expect(page).to have_content(topic_name)
      end
    end

    context 'as group admin' do
      it 'can pin/unpin a topic' do
        visit group_forum_topic_path(group, forum, topic)
        within_left_menu do
          click_link I18n.t("frm.topics.show.pin.false")
        end
        page_should_be_ok
        expect(page).to have_content(I18n.t('frm.topic.pinned.true'))
        within_left_menu do
          click_link I18n.t("frm.topics.show.pin.true")
        end
        page_should_be_ok
        expect(page).to have_content(I18n.t('frm.topic.pinned.false'))
      end
    end
  end

  #todo private forum should not be visible
  context 'viewing a topic' do
    it 'is free for all' do
      visit group_forum_topic_path(group, forum, topic)
      expect(page).to have_content(topic.subject)
      expect(page).to have_content(topic.posts.first.text)
    end
  end
end
