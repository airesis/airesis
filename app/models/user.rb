require 'digest/sha1'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :blockable, :traceable

  include TutorialAssigneesHelper

  attr_accessor :image_url, :accept_conditions, :accept_privacy

  validates_presence_of :name
  validates_format_of :name, with: AuthenticationModule.name_regex, allow_nil: true
  validates_length_of :name, maximum: 50

  validates_format_of :surname, with: AuthenticationModule.name_regex, allow_nil: true
  validates_length_of :surname, maximum: 50

  validates_confirmation_of :password

  validates_acceptance_of :accept_conditions, message: I18n.t('activerecord.errors.messages.TOS')
  validates_acceptance_of :accept_privacy, message: I18n.t('activerecord.errors.messages.privacy')

  has_many :proposal_presentations, dependent: :destroy # TODO: replace with anonymous
  has_many :proposals, through: :proposal_presentations, class_name: 'Proposal'
  has_many :notifications, through: :alerts, class_name: 'Notification'
  has_many :meeting_participations, dependent: :destroy
  has_one :blog, dependent: :destroy
  has_many :blog_comments, dependent: :destroy
  has_many :blog_posts, dependent: :destroy
  has_many :blocked_alerts, dependent: :destroy
  has_many :blocked_emails, dependent: :destroy

  has_many :event_comments, dependent: :destroy
  has_many :likes, class_name: 'EventCommentLike', dependent: :destroy

  has_many :group_participations, dependent: :destroy
  has_many :groups, through: :group_participations, class_name: 'Group'
  has_many :portavoce_groups, -> { joins(' INNER JOIN participation_roles ON participation_roles.id = group_participations.participation_role_id').where("(participation_roles.name = 'amministratore')") }, through: :group_participations, class_name: 'Group', source: 'group'

  has_many :area_participations, class_name: 'AreaParticipation'
  has_many :group_areas, through: :area_participations, class_name: 'GroupArea'

  has_many :participation_roles, through: :group_participations, class_name: 'ParticipationRole'
  has_many :group_follows, class_name: 'GroupFollow'
  has_many :followed_groups, through: :group_follows, class_name: 'Group', source: :group
  has_many :user_votes, class_name: 'UserVote'
  has_many :proposal_comments, class_name: 'ProposalComment'
  has_many :partecipating_proposals, through: :proposal_comments, class_name: 'Proposal', source: :proposal
  has_many :proposal_comment_rankings, class_name: 'ProposalCommentRanking'
  has_many :proposal_rankings, class_name: 'ProposalRanking'
  belongs_to :user_type, class_name: 'UserType', foreign_key: :user_type_id
  belongs_to :image, class_name: 'Image', foreign_key: :image_id
  has_many :authentications, class_name: 'Authentication', dependent: :destroy

  has_many :user_borders, class_name: 'UserBorder'

  # confini di interesse
  has_many :interest_borders, through: :user_borders, class_name: 'InterestBorder'

  has_many :alerts, -> { order('alerts.created_at DESC') }, class_name: 'Alert'
  has_many :unread_alerts, -> { where 'alerts.checked = false' }, class_name: 'Alert'

  has_many :blocked_notifications, through: :blocked_alerts, class_name: 'NotificationType', source: :notification_type
  has_many :blocked_email_notifications, through: :blocked_emails, class_name: 'NotificationType', source: :notification_type

  has_many :group_participation_requests, dependent: :destroy

  # record di tutti coloro che mi seguono
  has_many :followers_user_follow, class_name: 'UserFollow', foreign_key: :followed_id
  # tutti coloro che mi seguono
  has_many :followers, through: :followers_user_follow, class_name: 'User', source: :followed

  # record di tutti coloro che seguo
  has_many :followed_user_follow, class_name: 'UserFollow', foreign_key: :follower_id
  # tutti coloro che seguo
  has_many :followed, through: :followed_user_follow, class_name: 'User', source: :follower

  has_many :tutorial_assignees, dependent: :destroy
  has_many :tutorial_progresses, dependent: :destroy
  has_many :todo_tutorial_assignees, -> { where('tutorial_assignees.completed = false') }, class_name: 'TutorialAssignee'
  # tutorial assegnati all'utente
  has_many :tutorials, through: :tutorial_assignees, class_name: 'Tutorial', source: :user
  has_many :todo_tutorials, through: :todo_tutorial_assignees, class_name: 'Tutorial', source: :user

  belongs_to :locale, class_name: 'SysLocale', foreign_key: 'sys_locale_id'
  belongs_to :original_locale, class_name: 'SysLocale', foreign_key: 'original_sys_locale_id'

  has_many :events

  has_many :proposal_nicknames, dependent: :destroy

  has_one :certification, class_name: 'UserSensitive', foreign_key: :user_id, autosave: true

  # forum
  has_many :viewed, class_name: 'Frm::View'
  has_many :viewed_topics, class_name: 'Frm::Topic', through: :viewed, source: :viewable, source_type: 'Frm::Topic'
  has_many :unread_topics, -> { where 'frm_views.updated_at < frm_topics.last_post_at' }, class_name: 'Frm::Topic', through: :viewed, source: :viewable, source_type: 'Frm::Topic'
  has_many :memberships, class_name: 'Frm::Membership', foreign_key: :member_id
  has_many :frm_mods, through: :memberships, class_name: 'Frm::Mod', source: :mod

  before_create :init

  after_create :assign_tutorials, :block_alerts

  validate :check_uncertified

  # Check for paperclip
  has_attached_file :avatar,
                    styles: {
                      thumb: '100x100#',
                      small: '150x150>'
                    },
                    path: (Paperclip::Attachment.default_options[:storage] == :s3) ?
                      'avatars/:id/:style/:basename.:extension' : ':rails_root/public:url'

  validates_attachment_size :avatar, less_than: UPLOAD_LIMIT_IMAGES.bytes
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg']

  scope :all_except, ->(user) { where.not(id: user) }

  scope :blocked, -> { where(blocked: true) }
  scope :unblocked, -> { where(blocked: false) }
  scope :confirmed, -> { where 'confirmed_at is not null' }
  scope :unconfirmed, -> { where 'confirmed_at is null' }
  scope :certified, -> { where(user_type_id: UserType::CERTIFIED) }
  scope :count_active, -> { unblocked.count.to_f * (ENV['ACTIVE_USERS_PERCENTAGE'].to_f / 100.0) }

  scope :autocomplete, ->(term) { where('lower(users.name) LIKE :term or lower(users.surname) LIKE :term', term: "%#{term.to_s.downcase}%").order('users.surname desc, users.name desc').limit(10) }
  scope :non_blocking_notification, lambda { |notification_type|
    User.where.not(id: User.select('users.id').
                     joins(:blocked_alerts).
                     where(blocked_alerts: { notification_type_id: notification_type }))
  }

  validate :cannot_change_info_if_certified, on: :update

  def avatar_url=(url)
    file = URI.parse(url)
    self.avatar = file
  rescue
    # ignored
  end

  def check_uncertified
    if certified?
      if self.name_changed? || self.surname_changed?
        errors.add(:user_type_id, 'Non puoi modificare questi dati in quanto il tuo utente è certificato')
      end
    end
  end

  def suggested_groups
    border = interest_borders.first
    params = {}
    params[:interest_border_obj] = border
    params[:limit] = 12
    Group.look(params)
  end

  def email_required?
    super && !has_oauth_provider_without_email
  end

  def last_proposal_comment
    proposal_comments.order('created_at desc').first
  end

  # dopo aver creato un nuovo utente gli assegno il primo tutorial e
  # disattivo le notifiche standard
  def assign_tutorials
    Tutorial.all.each do |tutorial|
      assign_tutorial(self, tutorial)
    end
    GeocodeUser.perform_in(5.seconds, id)
  end

  def block_alerts
    blocked_alerts.create(notification_type_id: NotificationType::NEW_VALUTATION_MINE)
    blocked_alerts.create(notification_type_id: NotificationType::NEW_VALUTATION)
    blocked_alerts.create(notification_type_id: NotificationType::NEW_PUBLIC_EVENTS)
    blocked_alerts.create(notification_type_id: NotificationType::NEW_PUBLIC_PROPOSALS)
    blocked_alerts.create(notification_type: NotificationType.find_by(name: NotificationType::NEW_FORUM_TOPIC))
  end

  def init
    self.rank ||= 0 # imposta il rank a zero se non è valorizzato
    self.receive_messages = true
    self.receive_newsletter = true
  end

  # geocode user setting his default time zone
  def geocode
    @search = Geocoder.search(last_sign_in_ip)
    unless @search.empty? # continue only if we found latitude and longitude
      @latlon = [@search[0].latitude, @search[0].longitude]
      @zone = Timezone::Zone.new latlon: @latlon rescue nil # if we can't find the latitude and longitude zone just set zone to nil
      update_attribute(:time_zone, @zone.active_support_time_zone) if @zone # update zone if found
    end
  end

  # restituisce l'elenco delle partecipazioni ai gruppi dell'utente
  # all'interno dei quali possiede un determinato permesso
  def scoped_group_participations(abilitation)
    group_participations.joins(' INNER JOIN participation_roles ON participation_roles.id = group_participations.participation_role_id'\
                                      ' LEFT JOIN action_abilitations ON action_abilitations.participation_role_id = participation_roles.id '\
                                      ' and action_abilitations.group_id = group_participations.group_id').
      where("(participation_roles.name = 'amministratore' or action_abilitations.group_action_id = " + abilitation.to_s + ')')
  end

  # restituisce l'elenco dei gruppi dell'utente
  # all'interno dei quali possiede un determinato permesso
  def scoped_groups(abilitation, excluded_groups = nil)
    ret = groups.joins(' INNER JOIN participation_roles ON participation_roles.id = group_participations.participation_role_id'\
                              ' LEFT JOIN action_abilitations ON action_abilitations.participation_role_id = participation_roles.id '\
                              ' and action_abilitations.group_id = group_participations.group_id').
      where("(participation_roles.name = 'amministratore' or action_abilitations.group_action_id = " + abilitation.to_s + ')')
    excluded_groups ? ret - excluded_groups : ret
  end

  # return all group area participations of a particular group where the user can do a particular action or all group areas of the user in a group if abilitation_id is null
  def scoped_areas(group_id, abilitation_id = nil)
    group = Group.find(group_id)
    ret = nil
    if group.portavoce.include? self
      ret = group.group_areas
    elsif abilitation_id
      ret = group_areas.joins(area_roles: :area_action_abilitations).
        where(['group_areas.group_id = ? and area_action_abilitations.group_action_id = ?  and area_participations.area_role_id = area_roles.id', group_id, abilitation_id]).
        uniq
    else
      ret = group_areas.joins(:area_roles).
        where(['group_areas.group_id = ?', group_id]).
        uniq
    end
    ret
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      user.last_sign_in_ip = session[:remote_ip]
      user.subdomain = session[:subdomain] if session[:subdomain].present?
      user.original_sys_locale_id = user.sys_locale_id = SysLocale.default.id

      oauth_data = session['devise.omniauth_data']
      user_info = OauthDataParser.new(oauth_data).user_info if oauth_data

      if user_info
        user.email = user_info[:email]
      elsif (data = session[:user]) # what does it do? can't remember
        user.email = session[:user][:email]
        if invite = session[:invite] # if is by invitation
          group_invitation_email = GroupInvitationEmail.find_by(token: invite[:token])
          user.skip_confirmation! if user.email == group_invitation_email.email
        end
      end
    end
  end

  def last_blog_comment
    blog_comments
  end

  def encoded_id
    Base64.encode64(id)
  end

  def self.decode_id(id)
    Base64.decode64(id)
  end

  def image_url
    avatar.url
  end

  # determina se un oggetto appartiene all'utente verificando che
  # l'oggetto abbia un campo user_id corrispondente all'id dell'utente
  # in caso contrario verifica se l'oggetto ha un elenco di utenti collegati
  # e proprietari, in caso affermativo verifica di rientrare tra questi.
  def is_mine?(object)
    if object
      if object.respond_to?('user_id')
        return object.user_id == id
      elsif object.respond_to?('users')
        return object.users.find_by_id(id)
      else
        return false
      end
    else
      return false
    end
  end

  # questo metodo prende in input l'id di una proposta e verifica che l'utente ne sia l'autore
  def is_my_proposal?(proposal_id)
    proposal = proposals.find_by_id(proposal_id) # cerca tra le mie proposte quella con id 'proposal_id'
    if proposal # se l'ho trovata allora è mia
      true
    else
      false
    end
  end

  # questo metodo prende in input l'id di una proposta e verifica che l'utente ne sia l'autore
  def is_my_blog_post?(blog_post_id)
    blog_post = blog_posts.find_by_id(blog_post_id) # cerca tra le mie proposte quella con id 'proposal_id'
    if blog_post # se l'ho trovata allora è mia
      true
    else
      false
    end
  end

  # questo metodo prende in input l'id di un blog e verifica che appartenga all'utente
  def is_my_blog?(blog_id)
    if blog && blog.id == blog_id
      true
    else
      false
    end
  end

  def has_ranked_proposal?(proposal_id)
    ProposalRanking.where(user_id: id, proposal_id: proposal_id).exists?
  end

  # restituisce il voto che l'utente ha dato ad un determinato commento
  # se l'ha dato. nil altrimenti
  def comment_rank(comment)
    ranking = ProposalCommentRanking.find_by(user_id: id, proposal_comment_id: comment.id)
    ranking.try(:ranking_type_id)
  end

  # restituisce true se l'utente ha valutato un contributo
  # ma è stato successivamente inserito un commento e può quindi valutarlo di nuovo oppure il contributo è stato modificato
  def can_rank_again_comment?(comment)
    # return false unless comment.proposal.in_valutation? #can't change opinion if not in valutation anymore
    ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(id, comment.id)
    return true unless ranking # si, se non l'ho mai valutato
    return true if ranking.updated_at < comment.updated_at # si, se è stato aggiornato dopo la mia valutazione
    last_suggest = comment.replies.order('created_at desc').first
    return false unless last_suggest # no, se non vi è alcun commento
    ranking.updated_at < last_suggest.created_at # si, se vi sono commenti dopo la mia valutazione
  end

  def certified?
    user_type.short_name == 'certified'
  end

  def admin?
    user_type.short_name == 'admin'
  end

  def moderator?
    user_type.short_name == 'mod' || admin?
  end

  # restituisce la richiesta di partecipazione
  def has_asked_for_participation?(group_id)
    group_participation_requests.find_by(group_id: group_id)
  end

  def fullname
    "#{name} #{surname}"
  end

  def to_param
    "#{id}-#{fullname.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def can_read_forem_category?(category)
    category.visible_outside || (category.group.participants.include? self)
  end

  def can_read_forem_forum?(forum)
    forum.visible_outside || (forum.group.participants.include? self)
  end

  def can_create_forem_topics?(forum)
    forum.group.participants.include? self
  end

  def can_reply_to_forem_topic?(topic)
    topic.forum.group.participants.include? self
  end

  def can_edit_forem_posts?(forum)
    forum.group.participants.include? self
  end

  def can_read_forem_topic?(topic)
    !topic.hidden? || forem_admin?(topic.forum.group) || (topic.user == self)
  end

  def can_moderate_forem_forum?(forum)
    forum.moderator?(self)
  end

  def forem_admin?(group)
    self.can? :update, group
  end

  def to_s
    fullname
  end

  def user_image_url(size = 80, _params = {})
    if self.respond_to?(:user)
      user = self.user
    else
      user = self
    end

    if user.avatar.file?
      user.avatar.url
    else
      # Gravatar
      require 'digest/md5'
      if !user.email.blank?
        email = user.email
      else
        return ''
      end

      hash = Digest::MD5.hexdigest(email.downcase)
      "https://www.gravatar.com/avatar/#{hash}?s=#{size}"
    end
  end

  # authentication method
  def has_provider?(provider_name)
    authentications.find_by(provider: provider_name).present?
  end

  def from_identity_provider?
    authentications.any?
  end

  def build_authentication_provider(access_token)
    authentications.build(provider: access_token['provider'], uid: access_token['uid'], token: (access_token['credentials']['token'] rescue nil))
  end

  def facebook
    @fb_user ||= Koala::Facebook::API.new(authentications.find_by(provider: Authentication::FACEBOOK).token) rescue nil
  end

  def parma
    @parma_user ||= Parma::API.new(authentications.find_by(provider: Authentication::PARMA).token) rescue nil
  end

  # return the user, a flag indicating if it's the first time the oauth account
  # is associated to the Airesis account or if it's a simple login and another flag
  # indicating if the user has been found in th db by it's email
  def self.find_or_create_for_oauth_provider(oauth_data)
    oauth_data_parser = OauthDataParser.new(oauth_data)
    provider = oauth_data_parser.provider
    uid = oauth_data_parser.uid
    user_info = oauth_data_parser.user_info

    # se ho trovato l'id dell'utente prendi lui, altrimenti cercane uno con l'email uguale
    auth = Authentication.find_by(provider: provider, uid: uid)
    if auth
      # return user, first_association, found_from_email
      return auth.user, false, false
    else
      user = user_info[:email] && User.find_by(email: user_info[:email])
      # return user, first_association, found_from_email
      return user ? [user, true, true] : [create_account_for_oauth(oauth_data), true, false]
    end
  end

  def oauth_join(oauth_data)
    oauth_data_parser = OauthDataParser.new(oauth_data)
    provider = oauth_data_parser.provider
    raw_info = oauth_data_parser.raw_info
    user_info = oauth_data_parser.user_info

    User.transaction do
      build_authentication_provider(oauth_data)

      if user_info[:certified]
        certify_with_info(user_info)
      else
        self.email = user_info[:email] unless email
        set_social_network_pages(provider, raw_info)
      end

      save!
    end
  end

  def set_social_network_pages(provider, raw_info)
    self.google_page_url = raw_info['profile'] if provider == Authentication::GOOGLE
    self.linkedin_page_url = raw_info['publicProfileUrl'] if provider == Authentication::LINKEDIN
    self.facebook_page_url = raw_info['link'] if provider == Authentication::FACEBOOK
  end

  def twitter_page_url
    "https://twitter.com/intent/user?user_id=#{authentications.find_by(provider: Authentication::TWITTER).uid}"
  end

  def meetup_page_url
    "http://www.meetup.com/members/#{authentications.find_by(provider: Authentication::MEETUP).uid}"
  end

  def certify_with_info(user_info)
    fail 'Not enough info for certification' if [user_info[:name], user_info[:surname], user_info[:email]].any? &:blank?
    User.transaction do
      skip_reconfirmation!
      update!(email: user_info[:email], name: user_info[:name], surname: user_info[:surname])
      build_certification(name: user_info[:name], surname: user_info[:surname], tax_code: user_info[:tax_code])
      update!(user_type_id: UserType::CERTIFIED)
    end
  end

  protected

  def reconfirmation_required?
    self.class.reconfirmable && @reconfirmation_required
  end

  def self.create_account_for_oauth(oauth_data)
    oauth_data_parser = OauthDataParser.new(oauth_data)
    provider = oauth_data_parser.provider
    raw_info = oauth_data_parser.raw_info
    user_info = oauth_data_parser.user_info

    # Not enough info from oauth provider
    return nil if user_info[:name].blank?

    # A user cannot have more than one certified account
    return nil if oauth_data_parser.multiple_certification_attempt?

    user = User.new(name: user_info[:name],
                    surname: user_info[:surname],
                    password: Devise.friendly_token[0, 20],
                    sex: user_info[:sex],
                    email: user_info[:email])

    user.tap do |user|
      user.avatar_url = user_info[:avatar_url]

      user.google_page_url = raw_info['profile'] if provider == Authentication::GOOGLE
      user.linkedin_page_url = raw_info['publicProfileUrl'] if provider == Authentication::LINKEDIN
      user.facebook_page_url = raw_info['link'] if provider == Authentication::FACEBOOK

      User.transaction do
        user.build_authentication_provider(oauth_data)

        user.sign_in_count = 0
        user.confirm
        user.save!

        if user_info[:certified]
          user.build_certification(name: user.name, surname: user.surname, tax_code: user_info[:tax_code])
          user.update!(user_type_id: UserType::CERTIFIED)
        else
          user.update!(user_type_id: UserType::AUTHENTICATED)
        end
      end
      user.add_to_parma_group(raw_info['verified']) if provider == Authentication::PARMA
    end
  end

  def add_to_parma_group(verified)
    parma_group = Group.find_by(subdomain: 'parma')
    group_participation_requests.build(group: parma_group,
                                       group_participation_request_status_id: GroupParticipationRequestStatus::ACCEPTED)
    participation_role = group.default_role
    if verified
      # look for best role or fallback
      residente = ParticipationRole.where(['group_id = ? and lower(name) = ?', group.id, 'residente']).first
      participation_role = residente || participation_role
    end
    group_participations.build(group: group, participation_role_id: participation_role.id)
  end

  def cannot_change_info_if_certified
    if user_type_id == UserType::CERTIFIED
      [:name, :surname, :email].each do |field|
        errors.add(field, I18n.t('activerecord.errors.messages.certified_cannot_edit')) if send("#{field}_changed?")
      end
    end
  end

  def has_oauth_provider_without_email
    providers_without_email = [Authentication::TWITTER, Authentication::MEETUP, Authentication::LINKEDIN]
    providers_without_email.any? { |provider| has_provider?(provider) }
  end
end
