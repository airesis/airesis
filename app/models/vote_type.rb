class VoteType < ActiveRecord::Base
  POSITIVE = 1
  NEUTRAL = 2
  NEGATIVE = 3

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{short}.description")
  end
end
