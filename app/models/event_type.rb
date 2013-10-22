class EventType < ActiveRecord::Base
#  translates :description

  INCONTRO = 1
  VOTAZIONE = 2
  RIUNIONE = 3
  ELEZIONI = 4
  
  has_many :events, :class_name => 'Event'


  scope :active, conditions: {id: [1,2]}

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end
end
