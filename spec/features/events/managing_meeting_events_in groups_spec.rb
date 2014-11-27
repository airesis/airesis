require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe "manage correctly meeting events", type: :feature, js: true do

  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:group2) { create(:group, current_user_id: user2.id) }
  before :each do
    create_participation(user2, group)
    create_participation(user3, group)
  end

  it "participants can create meeting events" do
    #can manage his event
    login_as user2, scope: :user
    visit new_group_event_path(group)
    expect(page).to have_content(I18n.t('pages.events.new.title_meeting'))
    title = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph
    fill_in I18n.t('activerecord.attributes.event.title'), with: title
    fill_in I18n.t('activerecord.attributes.event.description'), with: description
    check I18n.t('activerecord.attributes.event.private')
    click_button I18n.t('buttons.next')
    fill_in I18n.t('activerecord.attributes.event.starttime'), with: (I18n.l Time.now, format: :datepicker)
    page.execute_script("$('#event_starttime').fdatetimepicker('hide');")
    fill_in I18n.t('activerecord.attributes.event.endtime'), with: (I18n.l Time.now + 1.day, format: :datepicker)
    page.execute_script("$('#event_endtime').fdatetimepicker('hide');")
    click_button I18n.t('buttons.next')
    #fill_in I18n.t('activerecord.attributes.event.meeting.place.comune_id'), with:
    #use the id for the generated div
    select2("Bologna", xpath: "//div[@id='s2id_event_meeting_attributes_place_attributes_comune_id']")
    fill_in I18n.t('activerecord.attributes.event.meeting.place.address'), with: 'Via Rizzoli 2'
    #page.execute_script("codeAddress('luogo');") google does not work during tests
    page.execute_script("$('#event_meeting_attributes_place_attributes_latitude_original').val(#{Faker::Address.latitude});")
    page.execute_script("$('#event_meeting_attributes_place_attributes_longitude_original').val(#{Faker::Address.longitude});")
    #find(:xpath, "//input[@id='event_meeting_attributes_place_attributes_longitude_original']").set Faker::Address.longitude
    #find(:xpath, "//input[@id='event_meeting_attributes_place_attributes_latitude_center']").set Faker::Address.latitude
    #find(:xpath, "//input[@id='event_meeting_attributes_place_attributes_longitude_center']").set Faker::Address.longitude

    click_button I18n.t('pages.events.new.submit')
    wait_for_ajax
    expect(page.current_path).to eq(group_events_path(group))
    expect(page).to have_content(title)
    visit group_event_path(group, Event.last)
    expect(page).to have_content(title)
    expect(page).to have_content(description)
    expect(Event.last.user).to eq user2
    logout :user
  end

  it "can delete events" do
    event = create(:meeting_event, user: user2)
    meeting_organization = create(:meeting_organization, event: event, group: group)
    meeting = create(:meeting, event: event)

    expect(Ability.new(user2)).to be_able_to(:destroy, event)

    event.destroy

    expect(Event.count).to eq 0
    expect(Meeting.count).to eq 0
    expect(MeetingOrganization.count).to eq 0
    expect(Place.count).to eq 0
  end

end
