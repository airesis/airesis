class Comune < ActiveRecord::Base
  has_many :places, :class_name => 'Place'
  belongs_to :provincia, :class_name => 'Provincia'
  has_one :regione, :class_name => 'Regione', through: :provincia
  has_one :stato, :class_name => 'Stato', through: :regione
  has_one :continente, class_name: 'Continente', through: :stato

  has_many :circoscriziones, :class_name => 'Circoscrizione'


  def parent
    self.provincia
  end
end
