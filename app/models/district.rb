class District < ActiveRecord::Base
  belongs_to :municipality
  belongs_to :province
  belongs_to :region
  belongs_to :country
  belongs_to :continent

  def parent
    municipality
  end
end
