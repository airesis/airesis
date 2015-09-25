class GroupAction < ActiveRecord::Base
  # insert posts in groups stream
  STREAM_POST = 1

  # create meeting events in the group
  CREATE_EVENT = 2

  # support proposals on behalf of the group
  SUPPORT_PROPOSAL = 3

  # accept participation request
  REQUEST_ACCEPT = 4

  # semd candidates to elections
  # @deprecated
  SEND_CANDIDATES = 5

  # view group private proposals
  PROPOSAL_VIEW = 6

  # participate at debate phase of the proposals
  PROPOSAL_PARTICIPATION = 7

  # insert new proposals
  PROPOSAL_INSERT = 8

  DOCUMENTS_VIEW = 9

  DOCUMENTS_MANAGE = 10

  # vote proposals
  PROPOSAL_VOTE = 11

  # choose date for proposals
  PROPOSAL_DATE = 12

  has_many :action_abilitations, class_name: 'ActionAbilitation', dependent: :destroy
  has_many :area_action_abilitations, class_name: 'AreaActionAbilitation', dependent: :destroy

  scope :for_group_areas, -> { where(id: DEFAULT_AREA_ACTIONS) }
  scope :excluding_ids, ->(ids) { where.not(id: ids) if ids.any? }

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{name}.description")
  end
end
