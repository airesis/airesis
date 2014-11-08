class EventType < ActiveRecord::Base
#  translates :description

  INCONTRO = 1
  VOTAZIONE = 2
  RIUNIONE = 3
  ELEZIONI = 4

  has_many :events

  scope :active, -> { where(id: [INCONTRO, VOTAZIONE]) }

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{name}.description")
  end
end
