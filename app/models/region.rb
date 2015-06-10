class Region < ActiveRecord::Base
  include Concerns::Bordable

  has_many :districts
  has_many :comunes
  has_many :provinces, dependent: :destroy

  belongs_to :country
  belongs_to :continent

  def parent
    country
  end

  def name
    I18n.t('interest_borders.region', name: description)
  end
end
