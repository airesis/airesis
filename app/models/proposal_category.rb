class ProposalCategory < ActiveRecord::Base
  NO_CATEGORY=5
  has_many :proposals, class_name: 'Proposal'

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end
end
