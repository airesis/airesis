class EventType < ActiveRecord::Base
  INCONTRO = 1
  VOTAZIONE = 2

  MEETING = INCONTRO
  VOTATION = VOTAZIONE

  has_many :events

  scope :active, -> { where(id: [MEETING, VOTATION]) }
  scope :meeting, -> { find_by(id: MEETING) }
  scope :votation, -> { find_by(id: VOTATION) }

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{name}.description")
  end
end
