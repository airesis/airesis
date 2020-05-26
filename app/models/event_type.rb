class EventType < ApplicationRecord
  MEETING = 1
  VOTATION = 2

  has_many :events

  scope :active, -> { where(id: [MEETING, VOTATION]) }
  scope :meeting, -> { find_by(id: MEETING) }
  scope :votation, -> { find_by(id: VOTATION) }

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{name}.description")
  end
end
