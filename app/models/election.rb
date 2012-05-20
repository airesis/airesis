class Election < ActiveRecord::Base
  belongs_to :event, :class_name => 'Event', :foreign_key => :event_id
  
  has_many :group_elections, :class_name => 'GroupElection'
  #gruppi che partecipano all'elezione
  has_many :groups, :through => :group_elections, :class_name => 'Group'
  #candidati all'elezione
  has_many :candidates, :class_name => 'Candidate'  
    
end
