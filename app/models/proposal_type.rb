class ProposalType < ActiveRecord::Base
  has_many :proposals, class_name: 'Proposal'

  SIMPLE = 'SIMPLE'
  STANDARD = 'STANDARD'
  POLL = 'POLL'
  RULE_BOOK = 'RULE_BOOK'
  PRESS = 'PRESS'
  EVENT = 'EVENT'
  ESTIMATE = 'ESTIMATE'
  AGENDA = 'AGENDA'
  CANDIDATE = 'CANDIDATE'
  PETITION = 'PETITION'

  scope :active, -> { where(active: true) }

  scope :for_groups, -> { where(groups_available: true) }

  scope :for_open_space, -> { where(open_space_available: true) }

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end

end
