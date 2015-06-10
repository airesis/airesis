class Province < ActiveRecord::Base
  include Concerns::Bordable

  self.table_name = 'provinces'

  has_many :comunes, dependent: :destroy
  has_many :districts

  belongs_to :region
  belongs_to :country
  belongs_to :continent

  def parent
    region
  end

  def name
    I18n.t('interest_borders.province', name: description)
  end
end
