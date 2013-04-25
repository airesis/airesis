#encoding: utf-8
class GroupArea < ActiveRecord::Base

  validates_presence_of :name
  validates_length_of :name, :within => 3..200
  validates_uniqueness_of :name, :scope => :group_id, :message => "Nome area già presente"

  validates_length_of :description, :within => 1..2000, :allow_nil => true
  validates_presence_of :group_id
  validates_presence_of :default_role_name, :on => :create

  attr_accessible :name, :description, :default_role_name, :default_role_actions

  attr_accessor :default_role_name, :default_role_actions, :current_user_id

  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
  belongs_to :default_role, :class_name => 'AreaRole', :foreign_key => :area_role_id

  has_many :area_partecipations, :class_name => 'AreaPartecipation', :dependent => :destroy, :order => 'id DESC'
  has_many :partecipants, :through => :area_partecipations, :source => :user, :class_name => 'User'

  has_many :area_proposals, :class_name => 'AreaProposal'#, :dependent => :destroy
  has_many :internal_proposals, :through => :area_proposals, :class_name => 'Proposal', :source => :proposal

  has_many :area_roles, :class_name => 'AreaRole', :dependent => :destroy, :order => 'id DESC'

  before_create :pre_populate
  after_create :after_populate

  def pre_populate

    role = self.area_roles.build({name: self.default_role_name, description: 'Ruolo predefinito dell\'area'})
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


  #utenti che possono votare
  def count_voter_partecipants
    self.partecipants.count(
        :joins => "join area_roles
               on area_partecipations.area_role_id = area_roles.id
               left join area_action_abilitations on area_roles.id = area_action_abilitations.area_role_id",
        :conditions => "(area_action_abilitations.group_action_id = 7 AND area_action_abilitations.group_area_id = #{self.id})")
  end

  #utenti che possono eseguire un'azione
  def scoped_partecipants(action_id)
    return self.partecipants.all(
        :joins => "join area_roles
               on area_partecipations.area_role_id = area_roles.id
               left join area_action_abilitations on area_roles.id = area_action_abilitations.area_role_id",
        :conditions => ["(area_action_abilitations.group_action_id = ? AND area_action_abilitations.group_area_id = ?) or (partecipation_roles.id = ?)", action_id, self.id, PartecipationRole::PORTAVOCE])
  end

  def to_param
    "#{id}-#{name.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

end
