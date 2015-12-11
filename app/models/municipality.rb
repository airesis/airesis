class Municipality < ActiveRecord::Base
  include Concerns::Bordable

  has_many :places, dependent: :destroy
  has_many :districts, dependent: :destroy

  belongs_to :province
  belongs_to :region
  belongs_to :country
  belongs_to :continent

  scope :by_hint, ->(hint) { where('lower_unaccent(municipalities.description) like lower_unaccent(?)', hint) }

  def parent
    province
  end

  def name
    I18n.t('interest_borders.town', name: description)
  end
end
