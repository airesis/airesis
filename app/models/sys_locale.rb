class SysLocale < ActiveRecord::Base
  has_many :users
  belongs_to :territory, polymorphic: true

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.name}.description")
  end

  def url
    url_ = "http://#{self.host}"
    url_ += "?l=#{self.lang}" if self.lang
    url_
  end

  def self.find_by_key(key)
    find_by(key: key) || find_by(key: key[0..1])
  end

  def self.default
    find_by(default: true)
  end
end
