class Regione < ActiveRecord::Base
  include Concerns::Bordable

  has_many :districts
  has_many :comunes
  has_many :provincias, dependent: :destroy

  belongs_to :country
  belongs_to :continente

  def parent
    country
  end

  def name
    I18n.t('interest_borders.region', name: description)
  end
end
