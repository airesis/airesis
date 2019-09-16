class Region < ActiveRecord::Base
  has_many :districts
  has_many :municipalities
  has_many :provinces, dependent: :destroy

  belongs_to :country
  belongs_to :continent

  scope :by_hint, ->(hint) { where('lower_unaccent(regions.description) like lower_unaccent(?)', hint) }

  def parent
    country
  end

  def name
    I18n.t('interest_borders.region', name: description)
  end
end
