class ParticipationRole < ActiveRecord::Base
  ADMINISTRATOR = 'amministratore'
  # MEMBER=1

  has_many :group_participations
  has_many :users, through: :group_participations, class_name: 'User'
  has_many :action_abilitations, dependent: :destroy
  has_many :group_actions, class_name: 'GroupAction', through: :action_abilitations
  belongs_to :participation_roles, class_name: 'ParticipationRole', foreign_key: :parent_participation_role_id
  belongs_to :group

  # prendi il portavoce, member è deprecato
  scope :common, -> { where(id: ParticipationRole.admin.id) }

  validates_uniqueness_of :name, scope: :group_id

  validates_presence_of :name, :description

  # prima di cancellare un ruolo assegna il ruolo di default a tutti coloro che avevano questo
  before_destroy :change_participation_roles

  # quando cancello un ruolo assegnato ad alcuni utenti, a tali utenti dagli il ruolo di default del gruppo
  def change_participation_roles
    group_participations.update_all(participation_role_id: group.participation_role_id) if group.present?
  end

  def self.admin
    @@admin ||= ParticipationRole.find_by(name: ADMINISTRATOR, group_id: nil)
  end
end
