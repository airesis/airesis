#encoding: utf-8
class GroupArea < ActiveRecord::Base

  validates :name, length: {within: 3..200}, uniqueness: {scope: :group_id, message: "Nome area già presente"}

  validates :description, length: {within: 1..2000}, allow_nil: true

  validates :group_id, presence: true
  validates :default_role_name, presence: true, on: :create

  attr_accessor :default_role_name, :default_role_actions, :current_user_id

  belongs_to :group, class_name: 'Group', foreign_key: :group_id
  belongs_to :default_role, class_name: 'AreaRole', foreign_key: :area_role_id

  has_many :area_participations, -> { order 'id DESC' }, class_name: 'AreaParticipation', dependent: :destroy
  has_many :participants, through: :area_participations, source: :user, class_name: 'User'

  has_many :area_proposals, class_name: 'AreaProposal' #, dependent: :destroy
  has_many :proposals, through: :area_proposals, class_name: 'Proposal', source: :proposal

  has_many :area_roles, -> { order 'id DESC' }, class_name: 'AreaRole', dependent: :destroy

  before_create :pre_populate
  after_create :after_populate

  def pre_populate
    role = area_roles.build({name: self.default_role_name, description: 'Ruolo predefinito dell\'area'})
    role.save!
    self.area_role_id = role.id
  end

  def after_populate
    self.default_role.update_attribute(:group_area_id, self.id)
    DEFAULT_AREA_ACTIONS.each do |action_id|
      abilitation = self.default_role.area_action_abilitations.build(group_action_id: action_id, group_area_id: self.id)
      abilitation.save!
    end
  end

  def destroy
    self.update_attribute(:area_role_id, nil) && super
  end

  #utenti che possono eseguire un'azione
  def scoped_participants(action_id)
    self.participants.
        joins(" join area_roles on area_participations.area_role_id = area_roles.id
            join area_action_abilitations on area_roles.id = area_action_abilitations.area_role_id").
        where(area_action_abilitations: {group_action_id: action_id, group_area_id: id}).
        uniq
  end

  def to_param
    "#{id}-#{name.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

end
