class Provincia < ActiveRecord::Base
  include Concerns::Bordable

  self.table_name = 'provincias'

  has_many :comunes, dependent: :destroy
  has_many :districts

  belongs_to :regione
  belongs_to :country
  belongs_to :continent

  def parent
    regione
  end

  def name
    I18n.t('interest_borders.province', name: description)
  end
end
