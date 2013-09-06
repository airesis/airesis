class ProposalCategory < ActiveRecord::Base
  #translates :description
  has_many :proposals, :class_name => 'Proposal'


  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end
end
