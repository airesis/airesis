class ParticipationRole < ApplicationRecord
  ADMINISTRATOR = 'amministratore'.freeze

  has_many :group_participations
  has_many :users, through: :group_participations, class_name: 'User'

  belongs_to :group, optional: true

  scope :common, -> { where(id: ParticipationRole.admin.id) }

  validates :name, uniqueness: { scope: :group_id }
  validates :name, :description, presence: true

  # before removing the role we need to assign the default role to all users associated with this role
  before_destroy :change_participation_roles

  def change_participation_roles
    group_participations.update_all(participation_role_id: group.participation_role_id) if group.present?
  end

  def self.admin
    ParticipationRole.find_by(name: ADMINISTRATOR, group_id: nil)
  end
end
