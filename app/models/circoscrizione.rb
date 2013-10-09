class Circoscrizione < ActiveRecord::Base
  belongs_to :comune, :class_name => 'Comune', :foreign_key => :comune_id
  has_one :provincia, :class_name => 'Provincia', through: :comune
  has_one :regione, :class_name => 'Regione', through: :provincia
  has_one :stato, :class_name => 'Stato', through: :regione
  has_one :continente, class_name: 'Continente', through: :stato

  def parent
    self.comune
  end
end
