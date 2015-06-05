class Provincia < ActiveRecord::Base
  include Concerns::Bordable

  self.table_name = 'provincias'

  has_many :comunes, dependent: :destroy
  has_many :circoscriziones

  belongs_to :regione
  belongs_to :stato
  belongs_to :continente

  def parent
    regione
  end

  def name
    I18n.t('interest_borders.province', name: description)
  end
end
