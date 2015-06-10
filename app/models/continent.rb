class Continent < ActiveRecord::Base
  include Concerns::Bordable
  translates :description

  has_many :districts
  has_many :comunes
  has_many :provinces
  has_many :regions
  has_many :countries

  def name
    I18n.t('interest_borders.continent', name: description)
  end
end
