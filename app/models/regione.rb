class Regione < ActiveRecord::Base
  has_many :provincias, class_name: 'Provincia'
  belongs_to :stato, class_name: 'Stato'
  has_one :continente, class_name: 'Continente', through: :stato

  def parent
    self.stato
  end
end
