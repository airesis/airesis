require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'manage correctly meeting events', :js, seeds: true do
  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:group2) { create(:group, current_user_id: user2.id) }

  before do
    create_participation(user2, group)
    create_participation(user3, group)
  end

  it 'participants can create meeting events' do
    login_as user2, scope: :user
    visit new_group_event_path(group)
    expect(page).to have_content(I18n.t('pages.events.new.title_meeting'))
    title = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph
    fill_in I18n.t('activerecord.attributes.event.title'), with: title
    fill_in I18n.t('activerecord.attributes.event.description'), with: description
    check I18n.t('activerecord.attributes.event.private')
    click_link I18n.t('buttons.next')
    fill_in I18n.t('activerecord.attributes.event.starttime'), with: (I18n.l Time.now, format: :datetimepicker)
    page.execute_script("$('#event_starttime').fdatetimepicker('hide');")
    fill_in I18n.t('activerecord.attributes.event.endtime'), with: (I18n.l Time.now + 1.day, format: :datetimepicker)
    page.execute_script("$('#event_endtime').fdatetimepicker('hide');")
    click_link I18n.t('buttons.next')
    select2ajax('#event_meeting_attributes_place_attributes_municipality_id', 'Bologna')
    fill_in I18n.t('activerecord.attributes.place.address'), with: 'Via Rizzoli 2'
    page.execute_script("$('#event_meeting_attributes_place_attributes_latitude_original').val(#{Faker::Address.latitude});")
    page.execute_script("$('#event_meeting_attributes_place_attributes_longitude_original').val(#{Faker::Address.longitude});")
    page.execute_script("$('#event_meeting_attributes_place_attributes_zoom').val(8);")

    click_link I18n.t('pages.events.new.submit')
    wait_for_ajax
    expect(page).to have_current_path(group_events_path(group))
    expect(page).to have_content(title)
    visit group_event_path(group, Event.last)
    expect(page).to have_content(title)
    expect(page).to have_content(description)
    expect(Event.last.user).to eq user2

    expect(NotificationEventCreate.jobs.size).to eq 1

    logout :user
  end

  it 'can delete events' do
    event = create(:meeting_event, user: user2)
    create(:meeting_organization, event: event, group: group)

    expect(Ability.new(user2)).to be_able_to(:destroy, event)

    event.destroy

    expect(Event.count).to eq 0
    expect(Meeting.count).to eq 0
    expect(MeetingOrganization.count).to eq 0
    expect(Place.count).to eq 0
  end
end
