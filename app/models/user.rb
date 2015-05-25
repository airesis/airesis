require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :omniauthable, #:reconfirmable,
         :recoverable, :rememberable, :trackable, :validatable, :blockable, :traceable

  include BlogKitModelHelper, TutorialAssigneesHelper
  #include Rails.application.routes.url_helpers

  attr_accessor :image_url, :accept_conditions, :subdomain, :accept_privacy

  #validates_presence_of     :login, unless: :from_identity_provider?
  #validates_length_of       :login,    within: 3..40, unless: :from_identity_provider?
  #validates_uniqueness_of   :login, unless: :from_identity_provider?
  #validates_format_of       :login,    with: AuthenticationModule.login_regex, message: AuthenticationModule.bad_login_message, unless: :from_identity_provider?

  validates_presence_of :name
  validates_format_of :name, with: AuthenticationModule.name_regex, allow_nil: true
  validates_length_of :name, maximum: 50

  validates_format_of :surname, with: AuthenticationModule.name_regex, allow_nil: true
  validates_length_of :surname, maximum: 50

  validates_length_of :email, within: 6..50, allow_nil: true #r@a.wk
  validates_format_of :email, with: AuthenticationModule.email_regex, message: AuthenticationModule.bad_email_message, allow_nil: true
  validates_uniqueness_of :email

  validates_confirmation_of :password

  validates_acceptance_of :accept_conditions, message: I18n.t('activerecord.errors.messages.TOS')
  validates_acceptance_of :accept_privacy, message: I18n.t('activerecord.errors.messages.privacy')

  #relations
  has_many :proposal_presentations, class_name: 'ProposalPresentation'
  has_many :proposals, through: :proposal_presentations, class_name: 'Proposal'
  has_many :notifications, through: :alerts, class_name: 'Notification'
  has_many :proposal_watches, class_name: 'ProposalWatch'
  has_many :meeting_participations, class_name: 'MeetingParticipation'
  has_one :blog, class_name: 'Blog'
  has_many :blog_comments, class_name: 'BlogComment'
  has_many :blog_posts, class_name: 'BlogPost'
  has_many :blocked_alerts, class_name: 'BlockedAlert'
  has_many :blocked_emails, class_name: 'BlockedEmail'

  has_many :event_comments, class_name: 'EventComment'
  has_many :likes, class_name: 'EventCommentLike'

  has_many :group_participations, class_name: 'GroupParticipation'
  has_many :groups, through: :group_participations, class_name: 'Group'
  has_many :portavoce_groups, -> { joins(" INNER JOIN participation_roles ON participation_roles.id = group_participations.participation_role_id").where("(participation_roles.name = 'amministratore')") }, through: :group_participations, class_name: 'Group', source: 'group'

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
  belongs_to :places, class_name: 'Place', foreign_key: :residenza_id
  belongs_to :places, class_name: 'Place', foreign_key: :nascita_id
  belongs_to :image, class_name: 'Image', foreign_key: :image_id
  has_many :authentications, class_name: 'Authentication', dependent: :destroy

  has_many :user_borders, class_name: 'UserBorder'

  #confini di interesse
  has_many :interest_borders, through: :user_borders, class_name: 'InterestBorder'

  has_many :alerts, -> { order('alerts.created_at DESC') }, class_name: 'Alert'
  has_many :unread_alerts, -> { where 'alerts.checked = false' }, class_name: 'Alert'

  has_many :blocked_notifications, through: :blocked_alerts, class_name: 'NotificationType', source: :notification_type
  has_many :blocked_email_notifications, through: :blocked_emails, class_name: 'NotificationType', source: :notification_type

  has_many :group_participation_requests, class_name: 'GroupParticipationRequest'

  #record di tutti coloro che mi seguono
  has_many :followers_user_follow, class_name: "UserFollow", foreign_key: :followed_id
  #tutti coloro che mi seguono
  has_many :followers, through: :followers_user_follow, class_name: "User", source: :followed

  #record di tutti coloro che seguo
  has_many :followed_user_follow, class_name: "UserFollow", foreign_key: :follower_id
  #tutti coloro che seguo
  has_many :followed, through: :followed_user_follow, class_name: "User", source: :follower

  has_many :tutorial_assignees, class_name: 'TutorialAssignee'
  has_many :tutorial_progresses, class_name: 'TutorialProgress'
  has_many :todo_tutorial_assignees, -> { where('tutorial_assignees.completed = false') }, class_name: 'TutorialAssignee'
  #tutorial assegnati all'utente
  has_many :tutorials, through: :tutorial_assignees, class_name: 'Tutorial', source: :user
  has_many :todo_tutorials, through: :todo_tutorial_assignees, class_name: 'Tutorial', source: :user

  belongs_to :locale, class_name: 'SysLocale', foreign_key: 'sys_locale_id'
  belongs_to :original_locale, class_name: 'SysLocale', foreign_key: 'original_sys_locale_id'


  has_many :events

  has_many :proposal_nicknames, class_name: 'ProposalNickname'

  has_one :certification, class_name: 'UserSensitive', foreign_key: :user_id

  #forum
  has_many :viewed, class_name: 'Frm::View'
  has_many :viewed_topics, class_name: 'Frm::Topic', through: :viewed, source: :viewable, source_type: 'Frm::Topic'
  has_many :unread_topics, -> { where 'frm_views.updated_at < frm_topics.last_post_at' }, class_name: 'Frm::Topic', through: :viewed, source: :viewable, source_type: 'Frm::Topic'
  has_many :memberships, class_name: 'Frm::Membership', foreign_key: :member_id
  has_many :frm_mods, through: :memberships, class_name: 'Frm::Mod', source: :mod

  before_create :init

  after_create :assign_tutorials

  validate :check_uncertified

  # Check for paperclip
  has_attached_file :avatar,
                    styles: {
                        thumb: "100x100#",
                        small: "150x150>"
                    },
                    path: "avatars/:id/:style/:basename.:extension"

  validates_attachment_size :avatar, less_than: 2.megabytes
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg']


  scope :blocked, -> { where(blocked: true) }
  scope :unblocked, -> { where(blocked: false) }
  scope :confirmed, -> { where 'confirmed_at is not null' }
  scope :unconfirmed, -> { where 'confirmed_at is null' }
  scope :certified, -> { where(user_type_id: UserType::CERTIFIED) }
  scope :count_active, -> { count.to_f * (ENV['ACTIVE_USERS_PERCENTAGE'].to_f / 100.0) }

  scope :autocomplete, ->(term) { where("lower(users.name) LIKE :term or lower(users.surname) LIKE :term", {term: "%#{term.downcase}%"}).order("users.surname desc, users.name desc").limit(10) }
  scope :non_blocking_notification, ->(notification_type) { User.where.not(id: User.select("users.id").joins(:blocked_alerts).where(blocked_alerts: {notification_type_id: notification_type})) }

  validate :cannot_change_info_if_certified, on: :update

  def avatar_url=(url)
    begin
      file = URI.parse(url)
      self.avatar = file
    rescue
      # ignored
    end
  end

  def check_uncertified
    if certified?
      if self.name_changed? || self.surname_changed?
        self.errors.add(:user_type_id, "Non puoi modificare questi dati in quanto il tuo utente è certificato")
      end
    end
  end


  def suggested_groups
    border = self.interest_borders.first
    params = {}
    params[:interest_border_obj] = border
    params[:limit] = 12
    Group.look(params)

  end


  def email_required?
    super && !(has_provider?(Authentication::TWITTER) || has_provider?(Authentication::LINKEDIN))
  end


  def last_proposal_comment
    self.proposal_comments.order('created_at desc').first
  end

  #dopo aver creato un nuovo utente gli assegno il primo tutorial e
  #disattivo le notifiche standard
  def assign_tutorials
    Tutorial.all.each do |tutorial|
      assign_tutorial(self, tutorial)
    end
    blocked_alerts.create(notification_type_id: NotificationType::NEW_VALUTATION_MINE)
    blocked_alerts.create(notification_type_id: NotificationType::NEW_VALUTATION)
    blocked_alerts.create(notification_type_id: NotificationType::NEW_PUBLIC_EVENTS)
    blocked_alerts.create(notification_type_id: NotificationType::NEW_PUBLIC_PROPOSALS)

    GeocodeUser.perform_in(5.seconds, self.id)
  end

  def init
    self.rank ||= 0 #imposta il rank a zero se non è valorizzato
    self.receive_messages = true
    self.receive_newsletter = true
  end


  #geocode user setting his default time zone
  def geocode
    @search = Geocoder.search(self.last_sign_in_ip)
    unless @search.empty? #continue only if we found latitude and longitude
      @latlon = [@search[0].latitude, @search[0].longitude]
      @zone = Timezone::Zone.new latlon: @latlon rescue nil #if we can't find the latitude and longitude zone just set zone to nil
      self.update_attribute(:time_zone, @zone.active_support_time_zone) if @zone #update zone if found
    end
  end

  #restituisce l'elenco delle partecipazioni ai gruppi dell'utente
  #all'interno dei quali possiede un determinato permesso
  def scoped_group_participations(abilitation)
    self.group_participations.joins(" INNER JOIN participation_roles ON participation_roles.id = group_participations.participation_role_id"+
                                        " LEFT JOIN action_abilitations ON action_abilitations.participation_role_id = participation_roles.id "+
                                        " and action_abilitations.group_id = group_participations.group_id")
        .where("(participation_roles.name = 'amministratore' or action_abilitations.group_action_id = " + abilitation.to_s + ")")
  end

  #restituisce l'elenco dei gruppi dell'utente
  #all'interno dei quali possiede un determinato permesso
  def scoped_groups(abilitation, excluded_groups=nil)
    ret = self.groups.joins(" INNER JOIN participation_roles ON participation_roles.id = group_participations.participation_role_id"+
                                " LEFT JOIN action_abilitations ON action_abilitations.participation_role_id = participation_roles.id "+
                                " and action_abilitations.group_id = group_participations.group_id")
              .where("(participation_roles.name = 'amministratore' or action_abilitations.group_action_id = " + abilitation.to_s + ")")
    excluded_groups ? ret - excluded_groups : ret
  end

  #return all group area participations of a particular group where the user can do a particular action or all group areas of the user in a group if abilitation_id is null
  def scoped_areas(group_id, abilitation_id=nil)
    group = Group.find(group_id)
    ret = nil
    if group.portavoce.include? self
      ret = group.group_areas
    elsif abilitation_id
      ret = group_areas.joins(area_roles: :area_action_abilitations)
                .where(['group_areas.group_id = ? and area_action_abilitations.group_action_id = ?  and area_participations.area_role_id = area_roles.id', group_id, abilitation_id])
                .uniq
    else
      ret = group_areas.joins(:area_roles)
                .where(['group_areas.group_id = ?', group_id])
                .uniq
    end
    ret
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      user.last_sign_in_ip = session[:remote_ip]
      user.subdomain = session[:subdomain] if (session[:subdomain] && !session[:subdomain].blank?)
      user.original_sys_locale_id =user.sys_locale_id = SysLocale.find_by(key: 'en').id

      fdata = session["devise.google_data"] || session["devise.facebook_data"] || session["devise.linkedin_data"] || session['devise.parma_data']
      data = fdata["extra"]["raw_info"] || fdata["info"] if fdata #raw-info for google and facebook and linkedin, info for parma
      if data
        user.email = data["email"]
        if fdata['provider'] == Authentication::LINKEDIN
          user.linkedin_page_url = data['publicProfileUrl']
          user.email = data["emailAddress"]
        elsif fdata['provider'] == Authentication::GOOGLE #do nothing
        elsif fdata['provider'] == Authentication::FACEBOOK #do nothing
        elsif fdata['provider'] == Authentication::PARMA #do nothing
        end
      elsif data = session[:user] #what does it do? can't remember
        user.email = session[:user][:email]
        user.login = session[:user][:email]
        if invite = session[:invite] #if is by invitation
          group_invitation_email = GroupInvitationEmail.find_by(token: invite[:token])
          if user.email == group_invitation_email.email
            user.skip_confirmation!
          end
        end
      end
    end
  end

  def last_blog_comment
    self.blog_comments
  end


  def encoded_id
    Base64.encode64(self.id)
  end

  def self.decode_id(id)
    Base64.decode64(id)
  end

  def image_url
    avatar.url
  end

  def login=(value)
    write_attribute :login, (value.try(:downcase))
  end

  #determina se un oggetto appartiene all'utente verificando che 
  #l'oggetto abbia un campo user_id corrispondente all'id dell'utente
  #in caso contrario verifica se l'oggetto ha un elenco di utenti collegati 
  #e proprietari, in caso affermativo verifica di rientrare tra questi.
  def is_mine?(object)
    if object
      if object.respond_to?('user_id')
        return object.user_id == self.id
      elsif object.respond_to?('users')
        return object.users.find_by_id(self.id)
      else
        return false
      end
    else
      return false
    end
  end

  #questo metodo prende in input l'id di una proposta e verifica che l'utente ne sia l'autore
  def is_my_proposal?(proposal_id)
    proposal = self.proposals.find_by_id(proposal_id) #cerca tra le mie proposte quella con id 'proposal_id'
    if (proposal) #se l'ho trovata allora è mia
      true
    else
      false
    end
  end

  #questo metodo prende in input l'id di una proposta e verifica che l'utente ne sia l'autore
  def is_my_blog_post?(blog_post_id)
    blog_post = self.blog_posts.find_by_id(blog_post_id) #cerca tra le mie proposte quella con id 'proposal_id'
    if (blog_post) #se l'ho trovata allora è mia
      true
    else
      false
    end
  end

  #questo metodo prende in input l'id di un blog e verifica che appartenga all'utente
  def is_my_blog?(blog_id)
    if (self.blog and self.blog.id == blog_id)
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

  #restituisce true se l'utente ha valutato un contributo
  #ma è stato successivamente inserito un commento e può quindi valutarlo di nuovo oppure il contributo è stato modificato
  def can_rank_again_comment?(comment)
    #return false unless comment.proposal.in_valutation? #can't change opinion if not in valutation anymore
    ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(self.id, comment.id)
    return true unless ranking #si, se non l'ho mai valutato
    return true if ranking.updated_at < comment.updated_at #si, se è stato aggiornato dopo la mia valutazione
    last_suggest = comment.replies.order('created_at desc').first
    return false unless last_suggest #no, se non vi è alcun commento
    ranking.updated_at < last_suggest.created_at #si, se vi sono commenti dopo la mia valutazione
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

  #restituisce la richiesta di partecipazione 
  def has_asked_for_participation?(group_id)
    group_participation_requests.find_by(group_id: group_id)
  end

  def fullname
    "#{name} #{surname}"
  end

  def to_param
    "#{id}-#{fullname.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(login) = :value OR lower(email) = :value", {value: login.downcase}]).first
    else
      where(conditions).first
    end
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

  def auto_subscribe?
    true
  end


  def can_moderate_forem_forum?(forum)
    forum.moderator?(self)
  end

  def forem_moderate_posts?
    false #todo
  end

  alias_method :forem_needs_moderation?, :forem_moderate_posts?

  def forem_approved_to_post?
    true
  end

  def forem_admin?(group)
    self.can? :update, group
  end

  def to_s
    fullname
  end


  #authentication method
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

  #gestisce l'azione di login tramite facebook
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] ##dati di facebook
    #se è presente un account facebook per l'utente usa quello
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'])
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    else
      user = User.find_by_email(data['email']) #altrimenti cercane uno con l'email uguale
    end
    return user if user

    #crea un nuovo account facebook
    if data["verified"]
      user = User.new(name: data["first_name"], surname: data["last_name"], sex: (data["gender"] ? data["gender"][0] : nil), email: data["email"], password: Devise.friendly_token[0, 20], facebook_page_url: data["link"])
      user.user_type_id = 3
      user.sign_in_count = 0
      user.build_authentication_provider(access_token)
      user.confirm!
      user.save(validate: false)
    else
      return nil
    end
    return user
  end


  #gestisce l'azione di login tramite linkedin
  def self.find_for_linkedin_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] ##dati di linkedin
    #se è presente un account linkedin per l'utente usa quello
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'])
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    else
      user = User.find_by_email(data['emailAddress']) #altrimenti cercane uno con l'email uguale
    end
    return user if user

    #crea un nuovo account linkedin
    user = User.new(name: data["firstName"], surname: data["lastName"], email: data["emailAddress"], password: Devise.friendly_token[0, 20], linkedin_page_url: data[:publicProfileUrl])
    user.avatar_url = data[:pictureUrl]
    user.user_type_id = 3
    user.sign_in_count = 0
    user.build_authentication_provider(access_token)
    user.confirm!
    user.save(validate: false)
    return user
  end


  #gestisce l'azione di login tramite google
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] #dati di google
    auth = Authentication.find_by(provider: access_token['provider'], uid: access_token['uid'])
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    else
      user = User.find_by(email: data['email']) #altrimenti cercane uno con l'email uguale
    end

    return user if user

    #create a new one
    user = User.new(name: data["given_name"], surname: data["family_name"], sex: (data["gender"] ? data["gender"][0] : nil), email: data["email"], password: Devise.friendly_token[0, 20], google_page_url: data["profile"])
    user.user_type_id = 3
    user.sign_in_count = 0
    user.build_authentication_provider(access_token)
    user.confirm!
    user.avatar = URI.parse(data['picture']) if data['picture']
    user.save(validate: false)
    user
  end


  #gestisce l'azione di login tramite twitter
  def self.find_for_twitter(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] #dati di twitter
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'])
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    end

    return user if user

    #crea un nuovo account twitter
    fullname = data["name"]
    splitted = fullname.split(' ', 2)
    name = splitted ? splitted[0] : fullname
    surname = splitted ? splitted[1] : ''
    user = User.new(name: name, surname: surname, password: Devise.friendly_token[0, 20])
    user.avatar_url = data[:profile_image_url]
    user.user_type_id = 3
    user.sign_in_count = 0
    user.build_authentication_provider(access_token)
    user.confirm!
    user.save(validate: false)
    return user
  end


  #gestisce l'azione di login tramite meetup
  def self.find_for_meetup(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] #dati di twitter
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'].to_s)
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    end

    return user if user

    #crea un nuovo account twitter
    fullname = data["name"]
    splitted = fullname.split(' ', 2)
    name = splitted ? splitted[0] : fullname
    surname = splitted ? splitted[1] : ''
    user = User.new(name: name, surname: surname, password: Devise.friendly_token[0, 20])
    user.avatar_url = data[:photo][:photo_link] if data[:photo]
    user.user_type_id = 3
    user.sign_in_count = 0
    user.build_authentication_provider(access_token)
    user.confirm!
    user.save(validate: false)
    return user
  end

  #gestisce l'azione di login tramite parma
  def self.find_for_parma(access_token, signed_in_resource=nil)
    data = access_token['info'] #dati di parma
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'].to_s)
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    else
      user = User.find_by_email(data['email']) #altrimenti cercane uno con l'email uguale
    end

    return user if user

    #crea un nuovo account parma

    user = User.new(name: data['first_name'].capitalize, surname: data['last_name'].capitalize, password: Devise.friendly_token[0, 20], email: data['email'])
    group = Group.find_by_subdomain('parma')
    user.group_participation_requests.build(group: group, group_participation_request_status_id: GroupParticipationRequestStatus::ACCEPTED)
    participation_role = group.default_role
    if data['verified']
      certification = user.build_certification({name: user.name, surname: user.surname, tax_code: user.email})
      participation_role = ParticipationRole.where(['group_id = ? and lower(name) = ?', group.id, 'residente']).first || participation_role #look for best role or fallback
      user.user_type_id = UserType::CERTIFIED
    else
      user.user_type_id = UserType::AUTHENTICATED
    end
    user.group_participations.build(group: group, participation_role_id: participation_role.id)

    user.sign_in_count = 0
    user.build_authentication_provider(access_token)
    user.confirm!
    user.save!

    #if data['verified']
    #  UserSensitive.create!({name: user.name, surname: user.surname, tax_code: user.email, user_id: user.id})
    #end

    return user
  end

  def self.find_or_create_for_tecnologiedemocratiche(oauth_data)

    raw_info = oauth_data['raw_info']

    #se ho trovato l'id dell'utente prendi lui, altrimenti cercane uno con l'email uguale
    auth = Authentication.find_by_provider_and_uid(oauth_data['provider'], oauth_data['uid'].to_s)
    user = auth ? auth.user : User.find_by_email(raw_info['email'])

    return user if user

    #crea un nuovo account TD
    user = User.new( name: raw_info['first_name'],
                    surname: raw_info['last_name'],
                    password: Devise.friendly_token[0, 20],
                    email: raw_info['email'] )

    user.build_certification({name: user.name, surname: user.surname, tax_code: user.email})
    user.user_type_id = UserType::CERTIFIED
    user.sign_in_count = 0
    user.build_authentication_provider(oauth_data)

    user.confirm!
    user.save!
  end

  # return the user and a flag indicating if it's the first time the oauth account
  # is associated to the Airesis account or if it's a simple login
  def self.find_or_create_for_oauth_provider(oauth_data)

    provider = oauth_data['provider'].to_s
    uid = oauth_data['uid'].to_s
    user_info = Authentication.oauth_user_info oauth_data

    #se ho trovato l'id dell'utente prendi lui, altrimenti cercane uno con l'email uguale
    auth = Authentication.find_by_provider_and_uid(provider, uid)
    if auth
      return auth.user, false, false
    else
      user = User.find_by_email( Authentication.oauth_user_info(oauth_data)[:email] )
      if user
        user.build_authentication_provider(oauth_data)
        if provider == Authentication::TECNOLOGIEDEMOCRATICHE || ( provider == Authentication::PARMA && raw_info['verified'] )
            user.certify_with_info(user_info)
        end
        return user, true, true
      else
        user = create_account_for_oauth(oauth_data)
        return user, true, false
      end
    end
  end

  def certify_with_info(user_info)

    raise "Not enough info for certification" if [ user_info[:name], user_info[:surname], user_info[:email] ].any? &:blank?

    skip_reconfirmation!
    update!(email: user_info[:email], name: user_info[:name], surname: user_info[:surname])
    build_certification({name: user_info[:name], surname: user_info[:surname], tax_code: user_info[:email]})
    update!( user_type_id: UserType::CERTIFIED )
  end

  protected

  def reconfirmation_required?
    self.class.reconfirmable && @reconfirmation_required
  end

  def self.create_account_for_oauth(oauth_data)

    provider = oauth_data['provider'].to_s
    raw_info = Authentication.oauth_raw_info oauth_data
    user_info = Authentication.oauth_user_info oauth_data

    return nil if [ user_info[:name], user_info[:surname], user_info[:email] ].any? &:blank?

    user = User.new( name: user_info[:name],
                     surname: user_info[:surname],
                     password: Devise.friendly_token[0, 20],
                     sex: user_info[:sex],
                     email: user_info[:email] )

    user.tap do |user|
      user.avatar_url = Authentication.oauth_avatar_url oauth_data

      user.google_page_url = raw_info['profile'] if provider == Authentication::GOOGLE
      user.linkedin_page_url = raw_info['publicProfileUrl'] if provider == Authentication::LINKEDIN
      user.facebook_page_url = raw_info['link'] if provider == Authentication::FACEBOOK

      user.confirm!
      user.save!

      if provider == Authentication::TECNOLOGIEDEMOCRATICHE || ( provider == Authentication::PARMA && raw_info['verified'] )
        user.build_certification({name: user.name, surname: user.surname, tax_code: user.email})
        user.update!( user_type_id: UserType::CERTIFIED )
      else
        user.update!( user_type_id: UserType::AUTHENTICATED )
      end

      User.add_to_parma_group( user, raw_info['verified'] ) if provider == Authentication::PARMA

      user.build_authentication_provider(oauth_data)
      user.sign_in_count = 0
    end
  end

  def self.add_to_parma_group(user, verified)
    parma_group = Group.find_by_subdomain('parma')
    user.group_participation_requests.build( group: parma_group,
                                             group_participation_request_status_id: GroupParticipationRequestStatus::ACCEPTED )
    participation_role = group.default_role
    if verified
      #look for best role or fallback
      residente = ParticipationRole.where(['group_id = ? and lower(name) = ?', group.id, 'residente']).first
      participation_role = residente || participation_role
    end
    user.group_participations.build(group: group, participation_role_id: participation_role.id)
  end

  def cannot_change_info_if_certified
    if user_type_id == UserType::CERTIFIED
      [:name, :surname, :email].each do |field|
        errors.add(field, I18n.t('activerecord.errors.messages.certified_cannot_edit')) if send("#{field}_changed?")
      end
    end
  end

end
