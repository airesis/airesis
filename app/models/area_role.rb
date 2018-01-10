class AreaRole < ActiveRecord::Base
  has_many :area_participations
  has_many :users, through: :area_participations

  belongs_to :group_area

  validates_uniqueness_of :name, scope: :group_area_id

  validates_presence_of :name, :description

  before_destroy :change_participation_roles

  # assign the default area role to all users which had this role
  def change_participation_roles
    area_participations.update_all(area_role_id: group_area.area_role_id) if group_area
  end
end
