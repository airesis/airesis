class Comune < ActiveRecord::Base

  has_many :places, :class_name => 'Place'
  has_many :circoscriziones, :class_name => 'Circoscrizione'

  belongs_to :provincia
  belongs_to :regione
  belongs_to :stato
  belongs_to :continente

end
