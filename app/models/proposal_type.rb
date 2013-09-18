class ProposalType < ActiveRecord::Base
  has_many :proposals, :class_name => 'Proposal'

  SIMPLE = 'SIMPLE'
  STANDARD = 'STANDARD'
  POLL = 'POLL'
  RULE_BOOK = 'RULE_BOOK'
  PRESS = 'PRESS'
  EVENT = 'EVENT'
  ESTIMATE = 'ESTIMATE'
  AGENDA = 'AGENDA'
  CANDIDATE = 'CANDIDATE'

  scope :active, where(:active => true)


  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end

end
