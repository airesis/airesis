class Country < ActiveRecord::Base
  include Concerns::Bordable
  translates :description

  has_many :districts
  has_many :comunes
  has_many :provinces
  has_many :regions

  belongs_to :continent

  def parent
    continent
  end

  def name
    I18n.t('interest_borders.country', name: description)
  end
end
