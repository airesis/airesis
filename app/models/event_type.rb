class EventType < ActiveRecord::Base
  has_many :events, :class_name => 'Event'
end
