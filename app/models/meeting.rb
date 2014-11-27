class Meeting < ActiveRecord::Base
  belongs_to :place, class_name: 'Place', foreign_key: :place_id
  has_many :meeting_organizations, class_name: 'MeetingOrganization'
  has_many :meeting_participations, class_name: 'MeetingParticipation', dependent: :destroy
  has_many :yes_participations, -> { where("meeting_participations.response = 'Y'") }, class_name: 'MeetingParticipation'
  has_many :no_participations, -> { where("meeting_participations.response = 'N'") }, class_name: 'MeetingParticipation'
  has_many :participants, -> { where("meeting_participations.response = 'Y'") }, through: :meeting_participations, class_name: 'User', source: :user
  belongs_to :event, class_name: 'Event', foreign_key: :event_id
  accepts_nested_attributes_for :place

  #TODO issue fixed in Rails 4.1. cannot put dependent: :destroy because it fails (foreign_key violation)
  #foreign keys are supported in rails 4.1 so it works
  after_destroy :delete_place

  protected

  def delete_place
    place.destroy
  end
end
