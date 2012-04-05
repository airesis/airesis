class Meeting < ActiveRecord::Base
  belongs_to :place, :class_name => 'Place', :foreign_key => :place_id, :dependent => :destroy
  has_many :meeting_organizations, :class_name => 'MeetingOrganization'
  has_many :meeting_partecipations, :class_name => 'MeetingPartecipation'
  has_many :yes_partecipations, :class_name => 'MeetingPartecipation', :conditions => 'meeting_partecipations.response = \'Y\''
  has_many :partecipants, :through => :meeting_partecipations, :class_name => 'User', :source => :user, :conditions => 'meeting_partecipations.response = \'Y\''
  belongs_to :event, :class_name => 'Event', :foreign_key => :event_id
  
  accepts_nested_attributes_for :place
end
