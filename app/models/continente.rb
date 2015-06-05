class Continente < ActiveRecord::Base
  include Concerns::Bordable
  translates :description
  self.table_name = 'continentes'

  has_many :circoscriziones
  has_many :comunes
  has_many :provincias
  has_many :regiones
  has_many :statos

  def name
    I18n.t('interest_borders.continent', name: description)
  end
end
