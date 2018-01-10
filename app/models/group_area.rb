class GroupArea < ActiveRecord::Base
  belongs_to :group
  belongs_to :default_role, class_name: 'AreaRole', foreign_key: :area_role_id

  has_many :area_participations, -> { order 'id DESC' }, dependent: :destroy
  has_many :participants, through: :area_participations, source: :user, class_name: 'User'

  has_many :area_proposals # , dependent: :destroy
  has_many :proposals, through: :area_proposals, class_name: 'Proposal', source: :proposal

  has_many :area_roles, -> { order 'id DESC' }, class_name: 'AreaRole', dependent: :destroy

  validates :name, length: { within: 3..200 }, uniqueness: { scope: :group_id, message: 'Nome area già presente' }
  validates :description, length: { within: 1..2000 }, allow_nil: true
  validates :group_id, presence: true
  validates :default_role_name, presence: true, on: :create

  attr_accessor :default_role_name, :default_role_actions, :current_user_id

  before_create :pre_populate
  after_create :after_populate

  def pre_populate
    role = area_roles.build(name: default_role_name, description: 'Ruolo predefinito dell\'area')
    role.save!
    self.area_role_id = role.id
  end

  def after_populate
    active_actions = Hash[DEFAULT_AREA_ACTIONS.map { |a| [a, true] }]
    default_role.update(active_actions.merge(group_area_id: id))
  end

  def destroy
    update_attribute(:area_role_id, nil) && super
  end

  # utenti che possono eseguire un'azione
  def scoped_participants(action)
    participants.
      joins('JOIN area_roles on area_participations.area_role_id = area_roles.id').
      where("area_roles.#{action} = true").
      uniq
  end

  def to_param
    "#{id}-#{name.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end
end
