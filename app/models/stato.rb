class Stato < ActiveRecord::Base
  include Concerns::Bordable
  translates :description

  has_many :circoscriziones
  has_many :comunes
  has_many :provincias
  has_many :regiones

  belongs_to :continente

  def parent
    continente
  end

  def name
    I18n.t('interest_borders.country', name: description)
  end
end
