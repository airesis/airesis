class Stato < ActiveRecord::Base
  translates :description

  has_many :circoscriziones
  has_many :comunes
  has_many :provincias
  has_many :regiones

  belongs_to :continente
end
