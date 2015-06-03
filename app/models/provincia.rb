class Provincia < ActiveRecord::Base
  self.table_name = 'provincias'

  has_many :comunes, dependent: :destroy
  has_many :circoscriziones

  belongs_to :regione
  belongs_to :stato
  belongs_to :continente

  def parent
    self.regione
  end
end
