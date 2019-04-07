class Group < ActiveRecord::Base
  extend FriendlyId
  include Concerns::Taggable
  include PgSearch

  pg_search_scope :search, lambda { |query, any_word = false|
    { query: query,
      against: { name: 'A', description: 'B' },
      order_within_rank: 'group_participations_count desc, created_at desc',
      using: { tsearch: { any_word: any_word } } }
  }

  friendly_id :name, use: [:slugged, :history]

  has_paper_trail versions: { class_name: 'GroupVersion' }

  include ImageHelper
  REQ_BY_PORTAVOCE = 'p'
  REQ_BY_VOTE = 'v'
  REQ_BY_BOTH = 'b'

  STATUS_ACTIVE = 'active'
  STATUS_FEW_USERS_A = 'few_users_a'

  validates :name, presence: true, uniqueness: true, length: { within: 3..60 }

  validates_presence_of :description
  validates_length_of :facebook_page_url, within: 10..255, allow_blank: true
  validates_length_of :title_bar, within: 1..255, allow_blank: true
  validates_presence_of :interest_border_id
  validates_presence_of :default_role_name, on: :create

  attr_reader :participant_tokens
  attr_accessor :default_role_name, :default_role_actions, :current_user_id

  has_many :group_follows, class_name: 'GroupFollow', dependent: :destroy
  has_many :post_publishings, class_name: 'PostPublishing', inverse_of: :group, dependent: :destroy

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
  has_many :next_events, -> { where(['endtime > ?', Time.now]) }, through: :meeting_organizations, class_name: 'Event', source: :event

  has_many :proposal_supports, class_name: 'ProposalSupport', dependent: :destroy
  has_many :supported_proposals, through: :proposal_supports, class_name: 'Proposal'

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
                    path: (Paperclip::Attachment.default_options[:storage] == :s3) ?
                            'groups/:id/:style/:basename.:extension' : ':rails_root/public:url',
                    default_url: '/img/gruppo-anonimo.png'

  validates_attachment_size :image, less_than: UPLOAD_LIMIT_IMAGES.bytes
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png', 'image/gif']

  scope :by_interest_border, ->(ib) { where('derived_interest_borders_tokens @> ARRAY[?]::varchar[]', ib) }

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

    active_actions = Hash[default_role_actions.map { |a| [a, true] }]
    participation_role = participation_roles.build(active_actions.merge(name: default_role_name,
                                                                        description: I18n.t('pages.groups.edit_permissions.default_role')))
    participation_role.save!
    self.default_role = participation_role
    self.max_storage_size = UPLOAD_LIMIT_GROUPS / 1024
  end

  def after_populate
    default_role.update_attribute(:group_id, id)

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
  def scoped_participants(action)
    participants.
      joins('JOIN participation_roles on group_participations.participation_role_id = participation_roles.id').
      where("participation_roles.#{action} = true").
      distinct
  end

  def participant_tokens=(ids)
    self.participant_ids = ids.split(',')
  end

  def interest_border_tkn
    interest_border_token
  end

  def interest_border_tkn=(tkn)
    unless tkn.blank?
      ftype = tkn[0, 1] # tipologia (primo carattere)
      fid = tkn[2..-1] # chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(tkn)
      if found # se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        self.interest_border_token = tkn
        interest_b = InterestBorder.find_or_create_by(territory_type: InterestBorder::I_TYPE_MAP[ftype], territory_id: fid)
        self.interest_border = interest_b

        derived_row = found
        while derived_row
          self.derived_interest_borders_tokens |= [InterestBorder.to_key(derived_row)]
          derived_row = derived_row.parent
        end
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
    query = params[:search]
    params[:and] = params[:and].nil? || params[:and]
    tag = params[:tag]

    page = params[:page] || 1
    limit = params[:limit] || 30

    if tag
      joins(:tags).where(tags: { text: tag }).order('group_participations_count desc, created_at desc').page(page).per(limit)
    else
      groups = if query.blank?
                 Group.order(group_participations_count: :desc, created_at: :desc)
               else
                 search(query, !params[:and])
               end
      if params[:interest_border]
        groups = if params[:area]
                   groups.by_interest_border(params[:interest_border])
                 else
                   groups.where(interest_border_token: params[:interest_border])
                 end
      end
      groups.page(page).per(limit)
    end
  end

  def self.most_active(territory = nil)
    groups = Group.includes(interest_border: :territory)
    if territory.present?
      groups = groups.by_interest_border(InterestBorder.to_key(territory))
    end
    groups.order(group_participations_count: :desc).page(1).per(5)
  end

  def should_generate_new_friendly_id?
    name_changed?
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
    FileUtils.mkdir_p dir # it automatically create "private" folder and doesn't error if the directory is already present
  end
end
