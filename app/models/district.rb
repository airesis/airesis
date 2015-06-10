class District < ActiveRecord::Base
  include Concerns::Bordable

  belongs_to :comune
  belongs_to :provincia
  belongs_to :region
  belongs_to :country
  belongs_to :continent

  def parent
    comune
  end
end
