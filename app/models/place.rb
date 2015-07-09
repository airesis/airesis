class Place < ActiveRecord::Base
  belongs_to :municipality
  has_one :meeting

  validates_presence_of :municipality_id, :address, :latitude_original, :longitude_original

end
