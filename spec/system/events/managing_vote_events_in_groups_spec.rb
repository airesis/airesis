require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'manage correctly vote events', :js, seeds: true do
  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:group2) { create(:group, current_user_id: user2.id) }

  before do
    create_participation(user2, group)
    create_participation(user3, group)
  end

  it 'participants can create vote events' do
    # can manage his event
    login_as user2, scope: :user
    visit new_group_event_path(group, event_type_id: EventType::VOTATION)
    expect(page).to have_content(I18n.t('pages.events.new.title_event'))
    title = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph
    fill_in I18n.t('activerecord.attributes.event.title'), with: title
    fill_in I18n.t('activerecord.attributes.event.description'), with: description

    click_link I18n.t('buttons.next')

    fill_in I18n.t('activerecord.attributes.event.starttime'), with: (I18n.l Time.now, format: :datetimepicker)
    page.execute_script("$('#event_starttime').fdatetimepicker('hide');")
    fill_in I18n.t('activerecord.attributes.event.endtime'), with: (I18n.l Time.now + 1.day, format: :datetimepicker)
    page.execute_script("$('#event_endtime').fdatetimepicker('hide');")

    click_link I18n.t('pages.events.new.submit')
    expect(page).to have_current_path(group_events_path(group))
    expect(page).to have_content(title)
    visit group_event_path(group, Event.last)
    expect(page).to have_content(title)
    expect(page).to have_content(description)
    expect(Event.last.user).to eq user2

    expect(NotificationEventCreate.jobs.size).to eq 1
    logout :user
  end
end
