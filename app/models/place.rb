class Place < ApplicationRecord
  belongs_to :municipality
  has_one :meeting

  validates :municipality_id, :address, :latitude_original, :longitude_original, presence: true
end
