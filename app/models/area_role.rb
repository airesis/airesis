class AreaRole < ActiveRecord::Base

  has_many :area_participations, class_name: 'AreaParticipation'
  has_many :users,through: :area_participations, class_name: 'User'
  has_many :area_action_abilitations, class_name: 'AreaActionAbilitation', dependent: :destroy
  has_many :area_actions, class_name: 'GroupAction', through: :area_action_abilitations, source: :group_action

  belongs_to :group_area, class_name: 'GroupArea', foreign_key: :group_area_id

  validates_uniqueness_of :name, scope: :group_area_id
  
  validates_presence_of :name, :description

  #prima di cancellare un ruolo assegna il ruolo di default a tutti coloro che avevano questo
  before_destroy :change_participation_roles

  #quando cancello un ruolo assegnato ad alcuni utenti, a tali utenti dagli il ruolo di default dell'area
  def change_participation_roles
    self.area_participations.update_all(area_role_id: self.group_area.area_role_id) if (self.group_area)
  end
end
