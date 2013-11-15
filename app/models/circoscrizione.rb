class Circoscrizione < ActiveRecord::Base
  belongs_to :comune
  belongs_to :provincia
  belongs_to :regione
  belongs_to :stato
  belongs_to :continente

  def parent
    self.comune
  end
end
