class Regione < ActiveRecord::Base
  has_many :circoscriziones
  has_many :comunes
  has_many :provincias

  belongs_to :stato
  belongs_to :continente

  def parent
    self.stato
  end
end
