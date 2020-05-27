class AreaRole < ApplicationRecord
  has_many :area_participations
  has_many :users, through: :area_participations

  # TODO: not optional, but is created before the area itself at the moment
  belongs_to :group_area, optional: true

  validates :name, uniqueness: { scope: :group_area_id }

  validates :name, :description, presence: true

  before_destroy :change_participation_roles

  # assign the default area role to all users which had this role
  def change_participation_roles
    area_participations.update_all(area_role_id: group_area.area_role_id) if group_area
  end
end
