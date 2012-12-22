class EventType < ActiveRecord::Base
  
  INCONTRO = 1
  VOTAZIONE = 2
  RIUNIONE = 3
  ELEZIONI = 4
  
  has_many :events, :class_name => 'Event'
end
