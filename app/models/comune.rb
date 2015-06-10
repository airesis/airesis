class Comune < ActiveRecord::Base
  include Concerns::Bordable

  has_many :places, dependent: :destroy
  has_many :districts, dependent: :destroy

  belongs_to :province
  belongs_to :region
  belongs_to :country
  belongs_to :continent

  def parent
    province
  end

  def name
    I18n.t('interest_borders.town', name: description)
  end
end
