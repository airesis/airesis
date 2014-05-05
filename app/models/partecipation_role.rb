class PartecipationRole < ActiveRecord::Base

  PORTAVOCE=2
  MEMBER=1

  has_many :group_partecipations, class_name: 'GroupPartecipation'
  has_many :users, through: :group_partecipations, class_name: 'User'
  has_many :action_abilitations, class_name: 'ActionAbilitation', dependent: :destroy
  has_many :group_actions, class_name: 'GroupAction', through: :action_abilitations#, order: 'group_actions.seq'
  belongs_to :partecipation_roles, class_name: 'PartecipationRole', foreign_key: :parent_partecipation_role_id
  belongs_to :group, class_name: 'Group', foreign_key: :group_id

  #prendi il portavoce, member è deprecato
  scope :common, -> {where(id: 2)}

  validates_uniqueness_of :name, scope: :group_id

  validates_presence_of :name, :description

  #prima di cancellare un ruolo assegna il ruolo di default a tutti coloro che avevano questo
  before_destroy :change_partecipation_roles

  #quando cancello un ruolo assegnato ad alcuni utenti, a tali utenti dagli il ruolo di default del gruppo
  def change_partecipation_roles
    self.group_partecipations.update_all(partecipation_role_id: self.group.partecipation_role_id) if (self.group)
  end
end
