class GroupAction < ActiveRecord::Base
#  translates :description
  #inserire post nello stream del gruppo
  STREAM_POST = 1

  #creare eventi nel gruppo
  CREATE_EVENT = 2
  #sostenere le proposte a nome del gruppo
  PROPOSAL = 3
  SUPPORT_PROPOSAL = 3

  #accettare le richieste di partecipazione al gruppo
  REQUEST_ACCEPT = 4

  #inviare candidati alle elezioni del gruppo
  SEND_CANDIDATES = 5

  #view proposals
  PROPOSAL_VIEW = 6

  #participate at debate phase of the proposals
  PROPOSAL_PARTICIPATION = 7

  #insert new proposals
  PROPOSAL_INSERT = 8

  DOCUMENTS_VIEW=9

  DOCUMENTS_MANAGE=10

  #vote proposals
  PROPOSAL_VOTE =11

  #choose date for proposals
  PROPOSAL_DATE =12
  
  
  has_many :action_abilitations, class_name: 'ActionAbilitation', dependent: :destroy
  has_many :area_action_abilitations, class_name: 'AreaActionAbilitation', dependent: :destroy


  scope :for_group_areas, -> {where(id: DEFAULT_AREA_ACTIONS)}
  scope :excluding_ids, ->(ids) { where('id NOT IN (?)', ids) if ids.any? }
  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end
end
