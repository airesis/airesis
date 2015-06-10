class District < ActiveRecord::Base
  include Concerns::Bordable

  belongs_to :comune
  belongs_to :provincia
  belongs_to :regione
  belongs_to :country
  belongs_to :continente

  def parent
    comune
  end
end
