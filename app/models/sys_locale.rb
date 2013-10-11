class SysLocale < ActiveRecord::Base

  has_many :users

  belongs_to :territory, polymorphic: true

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end

end
