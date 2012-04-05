class MeetingOrganization < ActiveRecord::Base
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
  belongs_to :event, :class_name => 'Event', :foreign_key => :event_id
end
