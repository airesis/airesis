class Meeting < ActiveRecord::Base
  belongs_to :place, :class_name => 'Place', :foreign_key => :place_id
  has_many :meetings_organizations, :class_name => 'MeetingsOrganization'
  has_many :meetings_partecipations, :class_name => 'MeetingsPartecipation'
  belongs_to :event, :class_name => 'Event', :foreign_key => :event_id
  
end
