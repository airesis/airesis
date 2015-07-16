class MeetingOrganization < ActiveRecord::Base
  belongs_to :group, counter_cache: true
  belongs_to :event
end
