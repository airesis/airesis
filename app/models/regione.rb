class Regione < ActiveRecord::Base
  include Concerns::Bordable

  has_many :circoscriziones
  has_many :comunes
  has_many :provincias, dependent: :destroy

  belongs_to :stato
  belongs_to :continente

  def parent
    stato
  end

  def name
    I18n.t('interest_borders.region', name: description)
  end
end
