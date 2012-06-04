class Election < ActiveRecord::Base
  belongs_to :event, :class_name => 'Event', :foreign_key => :event_id
  
  has_many :group_elections, :class_name => 'GroupElection'
  #gruppi che partecipano all'elezione
  has_many :groups, :through => :group_elections, :class_name => 'Group'
  #candidati all'elezione
  has_many :candidates, :class_name => 'Candidate'  
  
  has_many :election_votes, :class_name => 'ElectionVote'
  
  has_many :voters, :through => :election_votes, :class_name => 'User', :source => 'user'
  
  has_many :schulze_votes, :class_name => 'SchulzeVote'
  
  validates_presence_of :name, :description, :groups_end_time, :candidates_end_time
  validate :validate_groups_time_before_candidates_time
  
  def validate_groups_time_before_candidates_time
    if groups_end_time && candidates_end_time
      errors.add(:starttime, "La data di termine iscrizione gruppi deve essere antecedente la data termine iscrizione candidati") if groups_end_time > candidates_end_time
    end
  end
    
end
