class Continent < ActiveRecord::Base
  include Concerns::Bordable
  translates :description

  has_many :districts
  has_many :municipalities
  has_many :provinces
  has_many :regions
  has_many :countries

  scope :by_hint, lambda { |hint|
    with_translations(I18n.locale).
      where('lower_unaccent(continent_translations.description) like lower_unaccent(?)', hint)
  }

  def name
    I18n.t('interest_borders.continent', name: description)
  end
end
