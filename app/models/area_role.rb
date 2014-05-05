class AreaRole < ActiveRecord::Base

  has_many :area_partecipations, class_name: 'AreaPartecipation'
  has_many :users,through: :area_partecipations, class_name: 'User'
  has_many :area_action_abilitations, class_name: 'AreaActionAbilitation', dependent: :destroy
  has_many :area_actions, class_name: 'GroupAction', through: :area_action_abilitations, source: :group_action

  belongs_to :group_area, class_name: 'GroupArea', foreign_key: :group_area_id

  validates_uniqueness_of :name, scope: :group_area_id
  
  validates_presence_of :name, :description

  #prima di cancellare un ruolo assegna il ruolo di default a tutti coloro che avevano questo
  before_destroy :change_partecipation_roles

  #quando cancello un ruolo assegnato ad alcuni utenti, a tali utenti dagli il ruolo di default dell'area
  def change_partecipation_roles
    self.area_partecipations.update_all(area_role_id: self.group_area.area_role_id) if (self.group_area)
  end
end
