class Comune < ActiveRecord::Base
  include Concerns::Bordable

  has_many :places, class_name: 'Place'
  has_many :circoscriziones, class_name: 'Circoscrizione', dependent: :destroy

  belongs_to :provincia
  belongs_to :regione
  belongs_to :stato
  belongs_to :continente

  def parent
    provincia
  end

  def name
    I18n.t('interest_borders.town', name: description)
  end
end
