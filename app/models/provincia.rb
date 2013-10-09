class Provincia < ActiveRecord::Base
  self.table_name = 'provincias'
  belongs_to :regione, :class_name => 'Regione'
  has_one :stato, :class_name => 'Stato', through: :regione
  has_one :continente, class_name: 'Continente', through: :stato

  has_many :comunes, :class_name => 'Comune'

  def parent
    self.regione
  end
end
