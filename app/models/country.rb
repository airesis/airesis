class Country < ActiveRecord::Base
  include Concerns::Bordable
  translates :description

  has_many :districts
  has_many :municipalities
  has_many :provinces
  has_many :regions

  belongs_to :continent

  scope :by_hint, lambda { |hint|
    with_translations(I18n.locale, 'en').
      where('lower_unaccent(country_translations.description) like lower_unaccent(?)', hint).uniq
  }

  def parent
    continent
  end

  def name
    I18n.t('interest_borders.country', name: description)
  end
end
