class SysLocale < ActiveRecord::Base

  has_many :users

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end

end
