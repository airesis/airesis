class ParticipationRole < ActiveRecord::Base

  ADMINISTRATOR=2
  MEMBER=1

  has_many :group_participations, class_name: 'GroupParticipation'
  has_many :users, through: :group_participations, class_name: 'User'
  has_many :action_abilitations, class_name: 'ActionAbilitation', dependent: :destroy
  has_many :group_actions, class_name: 'GroupAction', through: :action_abilitations
  belongs_to :participation_roles, class_name: 'ParticipationRole', foreign_key: :parent_participation_role_id
  belongs_to :group, class_name: 'Group', foreign_key: :group_id

  #prendi il portavoce, member è deprecato
  scope :common, -> {where(id: 2)}

  validates_uniqueness_of :name, scope: :group_id

  validates_presence_of :name, :description

  #prima di cancellare un ruolo assegna il ruolo di default a tutti coloro che avevano questo
  before_destroy :change_participation_roles

  #quando cancello un ruolo assegnato ad alcuni utenti, a tali utenti dagli il ruolo di default del gruppo
  def change_participation_roles
    self.group_participations.update_all(participation_role_id: self.group.participation_role_id) if (self.group)
  end
end
