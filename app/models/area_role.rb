class AreaRole < ActiveRecord::Base
  has_many :area_participations
  has_many :users, through: :area_participations

  # TODO: remove those two
  has_many :area_action_abilitations, dependent: :destroy
  has_many :area_actions, class_name: 'GroupAction', through: :area_action_abilitations, source: :group_action

  belongs_to :group_area

  validates_uniqueness_of :name, scope: :group_area_id

  validates_presence_of :name, :description

  before_destroy :change_participation_roles

  # assign the default area role to all users which had this role
  def change_participation_roles
    area_participations.update_all(area_role_id: group_area.area_role_id) if group_area
  end
end
