class GroupAction < ActiveRecord::Base
#  translates :description
  #inserire post nello stream del gruppo
  STREAM_POST = 1

  #creare eventi nel gruppo
  CREATE_EVENT = 2
  #sostenere le proposte a nome del gruppo
  PROPOSAL = 3

  #accettare le richieste di partecipazione al gruppo
  REQUEST_ACCEPT = 4

  #inviare candidati alle elezioni del gruppo
  SEND_CANDIDATES = 5

  #view proposals
  PROPOSAL_VIEW = 6

  #partecipate at debate phase of the proposals
  PROPOSAL_PARTECIPATION = 7

  #insert new proposals
  PROPOSAL_INSERT = 8

  #vote proposals
  PROPOSAL_VOTE =11
  
  
  has_many :action_abilitations, :class_name => 'ActionAbilitation'


  scope :for_group_areas, :conditions => {id: DEFAULT_AREA_ACTIONS}

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end
end
