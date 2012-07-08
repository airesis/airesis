class Election < ActiveRecord::Base
  belongs_to :event, :class_name => 'Event', :foreign_key => :event_id
  
  has_many :group_elections, :class_name => 'GroupElection', :dependent => :destroy
  #gruppi che partecipano all'elezione
  has_many :groups, :through => :group_elections, :class_name => 'Group'
  #candidati all'elezione
  has_many :candidates, :class_name => 'Candidate'  
  
  has_many :election_votes, :class_name => 'ElectionVote'
  
  has_many :voters, :through => :election_votes, :class_name => 'User', :source => 'user'
  
  has_many :schulze_votes, :class_name => 'SchulzeVote'
  
  validates_presence_of :name, :description, :groups_end_time, :candidates_end_time
  validate :validate_groups_time_before_candidates_time
  
  #un'elezione che è attualmente in fase di iscrizione gruppi, ovvero l'evento è iniziato, non si è concluso e non è arrivato il termine per l'iscrizione dei gruppi'
  scope :groups_phase, :include => :event, :conditions => ['events.starttime < ? and events.endtime > ? and elections.groups_end_time > ?',Time.now,Time.now,Time.now]
  
  #un'elezione che è attualmente in fase di invio candidati, ovvero l'evento è iniziato, non si è concluso e il termine per l'iscrizione dei gruppi è stato raggiunto e non è arrivato il termine per l'invio dei candidati'
  scope :candidates_phase, :include => :event, :conditions => ['events.starttime < ? and events.endtime > ? and elections.candidates_end_time > ? and elections.groups_end_time < ?',Time.now,Time.now,Time.now,Time.now]
  
  #un'elezione che è attualmente in fase di voto, ovvero l'evento è iniziato, non si è concluso e si è conclusa l'iscrizione dei gruppi'
  scope :voting_phase, :include => :event, :conditions => ['events.starttime < ? and events.endtime > ? and elections.candidates_end_time < ?',Time.now,Time.now,Time.now]
  
  def validate_groups_time_before_candidates_time
    if groups_end_time && candidates_end_time
      errors.add(:starttime, "La data di termine iscrizione gruppi deve essere antecedente la data termine iscrizione candidati") if groups_end_time > candidates_end_time
    end
  end
  
  def is_groups_phase?
    return (self.event.is_now? && self.groups_end_time > Time.now)
  end
  
  def is_candidates_phase?
    return (self.event.is_now? && self.groups_end_time < Time.now && self.candidates_end_time > Time.now)
  end  
  
  def is_voting_phase?
    return (self.candidates_end_time < Time.now && !self.event.is_past?)
  end  
    
end
