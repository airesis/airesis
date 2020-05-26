class Province < ApplicationRecord
  has_many :municipalities, dependent: :destroy
  has_many :districts

  belongs_to :region
  belongs_to :country
  belongs_to :continent

  scope :by_hint, ->(hint) { where('lower_unaccent(provinces.description) like lower_unaccent(?)', hint) }

  def parent
    region
  end

  def name
    I18n.t('interest_borders.province', name: description)
  end
end
