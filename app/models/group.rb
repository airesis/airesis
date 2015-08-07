class Group < ActiveRecord::Base
  extend FriendlyId
  include Concerns::Taggable

  friendly_id :name, use: [:slugged, :history]

  has_paper_trail class_name: 'GroupVersion'

  include ImageHelper
  REQ_BY_PORTAVOCE = 'p'
  REQ_BY_VOTE = 'v'
  REQ_BY_BOTH = 'b'

  STATUS_ACTIVE = 'active'
  STATUS_FEW_USERS_A = 'few_users_a'

  validates :name, presence: true, uniqueness: true, length: {within: 3..60}

  validates_presence_of :description
  validates_length_of :facebook_page_url, within: 10..255, allow_blank: true
  validates_length_of :title_bar, within: 1..255, allow_blank: true
  validates_presence_of :interest_border_id
  validates_presence_of :default_role_name, on: :create

  attr_reader :participant_tokens
  attr_accessor :default_role_name, :default_role_actions, :current_user_id

  has_many :group_follows, class_name: 'GroupFollow', dependent: :destroy
  has_many :post_publishings, class_name: 'PostPublishing', dependent: :destroy

  has_many :group_participations, class_name: 'GroupParticipation', dependent: :destroy
  has_many :participants, through: :group_participations, source: :user, class_name: 'User'
  has_many :portavoce, -> { where(['group_participations.participation_role_id = ?', ParticipationRole.admin.id]) }, through: :group_participations, source: :user, class_name: 'User'

  has_many :followers, through: :group_follows, source: :user, class_name: 'User'
  has_many :blog_posts, through: :post_publishings, source: :blog_post
  has_many :participation_requests, class_name: 'GroupParticipationRequest', dependent: :destroy
  has_many :requesting, through: :participation_requests, source: :user, class_name: 'User'

  has_many :participation_roles, -> { order 'participation_roles.id DESC' }, class_name: 'ParticipationRole', dependent: :destroy
  belongs_to :interest_border, class_name: 'InterestBorder', foreign_key: :interest_border_id
  belongs_to :default_role, class_name: 'ParticipationRole', foreign_key: :participation_role_id
  has_many :meeting_organizations, class_name: 'MeetingOrganization', foreign_key: 'group_id', dependent: :destroy

  has_many :events, through: :meeting_organizations, class_name: 'Event', source: :event
  has_many :next_events, -> { where(['starttime > ?', Time.now]) }, through: :meeting_organizations, class_name: 'Event', source: :event

  has_many :proposal_supports, class_name: 'ProposalSupport', dependent: :destroy
  has_many :supported_proposals, through: :proposal_supports, class_name: 'Proposal'

  has_many :action_abilitations, class_name: 'ActionAbilitation'

  has_many :group_proposals, class_name: 'GroupProposal', dependent: :destroy
  has_many :proposals, through: :group_proposals, class_name: 'Proposal', source: :proposal

  has_many :group_quorums, class_name: 'GroupQuorum', dependent: :destroy
  has_many :quorums, -> { order 'seq nulls last, quorums.id' }, through: :group_quorums, class_name: 'BestQuorum', source: :quorum

  has_many :voters, -> { include(:participation_roles).where(['participation_roles.id = ?', ParticipationRole.admin.id]) }, through: :group_participations, source: :user, class_name: 'User'

  has_many :group_areas, dependent: :destroy

  has_many :search_participants

  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags, class_name: 'Tag'

  # invitations
  has_many :group_invitations
  has_many :group_invitation_emails, through: :group_invitations

  # forum
  has_many :forums, class_name: 'Frm::Forum', foreign_key: 'group_id', dependent: :destroy
  has_many :topics, through: :forums, class_name: 'Frm::Topic', source: :topics

  has_many :last_topics, through: :forums, class_name: 'Frm::Topic', source: :topics

  has_many :categories, class_name: 'Frm::Category', foreign_key: 'group_id', dependent: :destroy
  has_many :mods, class_name: 'Frm::Mod', foreign_key: 'group_id', dependent: :destroy

  has_one :statistic, class_name: 'GroupStatistic'

  # Check for paperclip
  has_attached_file :image,
                    styles: {
                      thumb: '100x100#',
                      medium: '300x300>',
                      small: '150x150>'
                    },
                    path: 'groups/:id/:style/:basename.:extension',
                    default_url: '/img/gruppo-anonimo.png'

  validates_attachment_size :image, less_than: 2.megabytes
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png', 'image/gif']

  before_create :pre_populate
  after_create :after_populate

  after_commit :create_folder

  before_save :normalize_blank_values

  def description
    super.try(:html_safe)
  end

  def normalize_blank_values
    [:admin_title].each do |att|
      self[att] = nil if self[att].blank?
    end
  end

  def pre_populate
    # creator is also administrator
    participation_requests.build(user_id: current_user_id, group_participation_request_status_id: 3)
    group_participations.build(user_id: current_user_id, participation_role: ParticipationRole.admin) # portavoce

    BestQuorum.visible.each do |quorum|
      copy = quorum.dup
      copy.public = false
      copy.save!
      group_quorums.build(quorum_id: copy.id)
    end
    role = participation_roles.build(name: default_role_name, description: I18n.t('pages.groups.edit_permissions.default_role'))
    default_role_actions.each do |action_id|
      abilitation = role.action_abilitations.build(group_action_id: action_id)
    end if default_role_actions
    role.save!
    self.participation_role_id = role.id
  end

  def after_populate
    default_role.update_attribute(:group_id, id)
    ids = default_role.action_abilitations.pluck(:id)
    ActionAbilitation.where(id: ids).update_all(group_id: id)

    # create default forums
    private = categories.create(name: I18n.t('frm.admin.categories.default_private'), visible_outside: false)
    private_f = private.forums.build(name: I18n.t('frm.admin.forums.default_private'), description: I18n.t('frm.admin.forums.default_private_description'), visible_outside: false)
    private_f.group = self
    private_f.save!

    public = categories.create(name: I18n.t('frm.admin.categories.default_public'))
    public_f = public.forums.create(name: I18n.t('frm.admin.forums.default_public'), description: I18n.t('frm.admin.forums.default_public_description'))
    public_f.group = self
    public_f.save!

    GroupStatistic.create(group_id: id, valutations: 0, vote_valutations: 0, good_score: 0).save!
  end

  def destroy
    update_attribute(:participation_role_id, ParticipationRole.admin.id) && super
  end

  # return true if the group is private and do not show anything to non-participants
  def is_private?
    private
  end

  # utenti che possono eseguire un'azione
  def scoped_participants(action_id)
    participants.
      joins(" join participation_roles on group_participations.participation_role_id = participation_roles.id
            join action_abilitations on participation_roles.id = action_abilitations.participation_role_id").
      where(action_abilitations: {group_action_id: action_id}).
      uniq
  end

  def participant_tokens=(ids)
    self.participant_ids = ids.split(',')
  end

  def interest_border_tkn
    "#{interest_border.territory_type}-#{interest_border.territory_id}" if interest_border
  end

  def interest_border_tkn=(tkn)
    unless tkn.blank?
      ftype = tkn[0, 1] # tipologia (primo carattere)
      fid = tkn[2..-1] # chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(tkn)
      if found # se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        interest_b = InterestBorder.find_or_create_by(territory_type: InterestBorder::I_TYPE_MAP[ftype], territory_id: fid)
        self.interest_border = interest_b
      end
    end
  end

  def request_by_vote?
    accept_requests == REQ_BY_VOTE
  end

  def request_by_portavoce?
    accept_requests == REQ_BY_PORTAVOCE
  end

  def request_by_both?
    accept_requests == REQ_BY_BOTH
  end

  def self.look(params)
    search = params[:search]
    params[:minimum] = params[:and] ? nil : 1

    tag = params[:tag]

    page = params[:page] || 1
    limite = params[:limit] || 30

    if tag
      Group.joins(:tags).where(tags: {text: tag}).order('group_participations_count desc, created_at desc').page(page).per(limite)
    else
      Group.search(include: [:next_events, interest_border: [:territory]]) do
        fulltext search, minimum_match: params[:minimum] if search
        # retrieve all possible interest borders
        if params[:interest_border_obj]
          border = params[:interest_border_obj]
          if params[:area]
            with(:interest_border_id, border.id)
          else
            with(border.solr_search_field, border.territory.id) if border.present?
          end
        end
        order_by :score, :desc
        order_by :group_participations_count, :desc
        order_by :created_at, :desc

        paginate page: page, per_page: limite
      end.results
    end
  end

  def self.most_active(territory = nil)
    Group.search(include: {interest_border: [:territory]}) do
      with(territory.solr_search_field, territory.id) if territory.present?
      order_by :group_participations_count, :desc
      paginate page: 1, per_page: 5
    end.results
  end

  searchable do
    text :name, boost: 5
    text :description
    integer :id
    integer :interest_border_id
    integer :group_participations_count
    time :created_at
    integer :continent_ids do
      interest_border.continent.try(:id)
    end
    integer :country_ids do
      interest_border.country.try(:id)
    end
    integer :region_ids do
      interest_border.region.try(:id)
    end
    integer :province_ids do
      interest_border.province.try(:id)
    end
    integer :municipality_ids do
      interest_border.municipality.try(:id)
    end
    integer :district_ids do
      interest_border.district.try(:id)
    end
  end

  private

  def self.autocomplete(term)
    where('lower(groups.name) LIKE :term', term: "%#{term.downcase}%").
      limit(10).
      select('groups.name, groups.id, groups.image_id, groups.image_url, groups.image_file_name').
      order('groups.name asc')
  end

  def create_folder
    dir = "#{Rails.root}/private/elfinder/#{id}"
    Dir.mkdir dir unless File.exist?(dir)
  end
end
