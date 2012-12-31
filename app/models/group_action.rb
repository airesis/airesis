class GroupAction < ActiveRecord::Base

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

  #visualizzare le proposte
  PROPOSAL_VIEW = 6

  #partecipare alle proposte
  PROPOSAL_PARTECIPATION = 7

  #inserire nuove proposte
  PROPOSAL_INSERT = 8
  
  
  has_many :action_abilitations, :class_name => 'ActionAbilitation'  
end
