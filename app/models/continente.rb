class Continente < ActiveRecord::Base
  translates :description
  self.table_name = 'continentes'

  has_many :circoscriziones
  has_many :comunes
  has_many :provincias
  has_many :regiones
  has_many :statos

end
