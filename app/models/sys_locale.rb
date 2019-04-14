class SysLocale < ActiveRecord::Base
  has_many :users, inverse_of: :locale
  has_many :original_users, inverse_of: :original_locale
  belongs_to :territory, polymorphic: true
  validates :key, uniqueness: true

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{key}.description")
  end

  def url
    url_ = "http://#{host}"
    url_ += "?l=#{lang}" if lang
    url_
  end

  def self.find_by_key(key)
    find_by(key: key) || find_by(key: key[0..1])
  end

  def self.default
    find_by(default: true)
  end
end
