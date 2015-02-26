class Place < ActiveRecord::Base
  belongs_to :comune, class_name: 'Comune', foreign_key: :comune_id
  #has_many :users, class_name: 'User'
  #has_many :users, class_name: 'User'
  has_one :meeting, class_name: 'Meeting'

  #  belongs_to :event, class_name: 'Event'

  validates_presence_of :comune_id, :address, :latitude_original, :longitude_original

end
