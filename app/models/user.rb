#encoding: utf-8
require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :omniauthable, #:reconfirmable,
         :recoverable, :rememberable, :trackable, :validatable, :blockable, :token_authenticatable

  include BlogKitModelHelper, TutorialAssigneesHelper
  #include Rails.application.routes.url_helpers

  #validates_presence_of     :login, :unless => :from_identity_provider?
  #validates_length_of       :login,    :within => 3..40, :unless => :from_identity_provider?
  #validates_uniqueness_of   :login, :unless => :from_identity_provider?
  #validates_format_of       :login,    :with => AuthenticationModule.login_regex, :message => AuthenticationModule.bad_login_message, :unless => :from_identity_provider?

  validates_presence_of :name
  validates_format_of :name, :with => AuthenticationModule.name_regex, :allow_nil => true
  validates_length_of :name, :maximum => 50

  validates_format_of :surname, :with => AuthenticationModule.name_regex, :allow_nil => true
  validates_length_of :surname, :maximum => 50

  validates_length_of :email, :within => 6..50, :allow_nil => true #r@a.wk
  validates_format_of :email, :with => AuthenticationModule.email_regex, :message => AuthenticationModule.bad_email_message, :allow_nil => true
  validates_uniqueness_of :email

  validates_format_of :blog_image_url, :with => AuthenticationModule.url_regex, :allow_nil => true
  validates_confirmation_of :password

  validates_acceptance_of :accept_conditions, :message => "E' necessario accettare le condizioni d'uso"

  #colonne assegnabili massivamente
  attr_accessible :login, :name, :email, :surname, :password, :password_confirmation, :blog_image_url, :sex, :remember_me, :accept_conditions, :email_alerts, :facebook_page_url, :linkedin_page_url, :google_page_url

  #relations
  has_many :proposal_presentations, :class_name => 'ProposalPresentation'
  has_many :proposals, :through => :proposal_presentations, :class_name => 'Proposal'
  has_many :notifications, :through => :user_alerts, :class_name => 'Notification'
  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_many :meeting_partecipations, :class_name => 'MeetingPartecipation'
  has_one :blog, :class_name => 'Blog'
  has_many :blog_comments, :class_name => 'BlogComment'
  has_many :blog_posts, :class_name => 'BlogPost'
  has_many :blocked_alerts, :class_name => 'BlockedAlert'
  has_many :blocked_emails, :class_name => 'BlockedEmail'

  has_many :group_partecipations, :class_name => 'GroupPartecipation'
  has_many :groups, :through => :group_partecipations, :class_name => 'Group'

  has_many :area_partecipations, :class_name => 'AreaPartecipation'
  has_many :group_areas, :through => :area_partecipations, :class_name => 'GroupArea'

  has_many :partecipation_roles, :through => :group_partecipations, :class_name => 'PartecipationRole'
  has_many :group_follows, :class_name => 'GroupFollow'
  has_many :followed_groups, :through => :group_follows, :class_name => 'Group', :source => :group
  has_many :user_votes, :class_name => 'UserVote'
  has_many :proposal_comments, :class_name => 'ProposalComment'
  has_many :proposal_comment_rankings, :class_name => 'ProposalCommentRanking'
  has_many :proposal_rankings, :class_name => 'ProposalRanking'
  belongs_to :user_type, :class_name => 'UserType', :foreign_key => :user_type_id
  belongs_to :places, :class_name => 'Place', :foreign_key => :residenza_id
  belongs_to :places, :class_name => 'Place', :foreign_key => :nascita_id
  belongs_to :image, :class_name => 'Image', :foreign_key => :image_id
  has_many :authentications, :class_name => 'Authentication'

  has_many :user_borders, :class_name => 'UserBorder'

  #confini di interesse
  has_many :interest_borders, :through => :user_borders, :class_name => 'InterestBorder'

  has_many :user_alerts, :class_name => 'UserAlert', :order => 'created_at DESC'
  has_many :blocked_notifications, :through => :blocked_alerts, :class_name => 'NotificationType', :source => :notification_type
  has_many :blocked_email_notifications, :through => :blocked_emails, :class_name => 'NotificationType', :source => :notification_type

  has_many :group_partecipation_requests, :class_name => 'GroupPartecipationRequest'

  #record di tutti coloro che mi seguono
  has_many :followers_user_follow, :class_name => "UserFollow", :foreign_key => :followed_id
  #tutti coloro che mi seguono
  has_many :followers, :through => :followers_user_follow, :class_name => "User", :source => :followed

  #record di tutti coloro che seguo
  has_many :followed_user_follow, :class_name => "UserFollow", :foreign_key => :follower_id
  #tutti coloro che seguo
  has_many :followed, :through => :followed_user_follow, :class_name => "User", :source => :follower

  has_many :tutorial_assignees, :class_name => 'TutorialAssignee'
  has_many :tutorial_progresses, :class_name => 'TutorialProgress'
  has_many :todo_tutorial_assignees, :class_name => 'TutorialAssignee', :conditions => 'tutorial_assignees.completed = false'
  #tutorial assegnati all'utente
  has_many :tutorials, :through => :tutorial_assignees, :class_name => 'Tutorial', :source => :user
  has_many :todo_tutorials, :through => :todo_tutorial_assignees, :class_name => 'Tutorial', :source => :user


  #affinità con i gruppi
  has_many :group_affinities, :class_name => 'GroupAffinity'

  has_many :suggested_groups, :through => :group_affinities, :class_name => "Group", :order => "group_affinities.value desc", :limit => 10, :source => :group


  #candidature
  has_many :candidates, :class_name => 'Candidate'

  has_many :proposal_nicknames, :class_name => 'ProposalNickname'

  #fake columns
  attr_accessor :image_url, :accept_conditions

  before_create :init

  after_create :assign_tutorials

  scope :blocked, {:conditions => {:blocked => true}}
  scope :confirmed, {:conditions => 'confirmed_at is not null'}
  scope :unconfirmed, {:conditions => 'confirmed_at is null'}


  def email_required?
    super && !(has_provider('twitter') || has_provider('linkedin'))
  end

  #dopo aver creato un nuovo utente gli assegno il primo tutorial e
  #disattivo le notifiche standard
  def assign_tutorials
    tutorial = Tutorial.find_by_name("Welcome Tutorial")
    assign_tutorial(self, tutorial)
    tutorial = Tutorial.find_by_name("First Proposal")
    assign_tutorial(self, tutorial)
    tutorial = Tutorial.find_by_name("Rank Bar")
    assign_tutorial(self, tutorial)
    self.blocked_alerts.create(:notification_type_id => 20)
    self.blocked_alerts.create(:notification_type_id => 21)
    self.blocked_alerts.create(:notification_type_id => 13)
    self.blocked_alerts.create(:notification_type_id => 3)
  end

  def init
    self.rank ||= 0 #imposta il rank a zero se non è valorizzato
    self.receive_messages = true
    self.email_alerts = true
  end


  #restituisce l'elenco delle partecipazioni ai gruppi dell'utente
  #all'interno dei quali possiede un determinato permesso
  def scoped_group_partecipations(abilitation)
    self.group_partecipations.joins(" INNER JOIN partecipation_roles ON partecipation_roles.id = group_partecipations.partecipation_role_id"+
                                        " LEFT JOIN action_abilitations ON action_abilitations.partecipation_role_id = partecipation_roles.id "+
                                        " and action_abilitations.group_id = group_partecipations.group_id")
    .all(:conditions => "(partecipation_roles.name = 'portavoce' or action_abilitations.group_action_id = " + abilitation.to_s + ")")
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      fdata = session["devise.google_data"] || session["devise.facebook_data"] || session["devise.linkedin_data"]
      data = fdata["extra"]["raw_info"] if fdata
      if data
        user.email = data["email"]
        if fdata['provider'] == Authentication::LINKEDIN
          user.linkedin_page_url = data['publicProfileUrl']
          user.email = data["emailAddress"]
        elsif fdata['provider'] == Authentication::GOOGLE
        elsif fdata['provider'] == Authentication::FACEBOOK
        end
      elsif data = session[:user]
        user.email = session[:user][:email]
        user.login = session[:user][:email]
        if invite = session[:invite]
          group_invitation = GroupInvitation.find_by_token(invite[:token])
          if user.email == group_invitation.group_invitation_email.email
            user.skip_confirmation!
          end
        end
      end
    end
  end

  def last_blog_comment
    self.blog_comments
  end


  def image_url
    if (self.blog_image_url && !self.blog_image_url.blank?)
      return self.blog_image_url
    elsif (self.image_id)
      return self.image.image.url
    else
      return ""
    end
  end


  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
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

  def has_provider(provider_name)
    return self.authentications.where(:provider => provider_name).count > 0
  end

  def from_identity_provider?
    return self.authentications.count > 0
  end

  def has_ranked_proposal?(proposal_id)
    ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id, proposal_id)
    if ranking
      return true
    else
      return false
    end
  end

  #restituisce il voto che l'utente ha dato ad un determinato commento
  #se l'ha dato. nil altrimenti
  def comment_rank(comment)
    ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(self.id, comment.id)
    if ranking
      return ranking.ranking_type_id
    else
      return nil
    end
  end

  #restituisce true se l'utente ha valutato un contributo
  #ma il contributo è stato successivamente modificato e può quindi valutarlo di nuovo 
  def can_rank_again_comment?(comment)
    if (comment.proposal.proposal_state_id != PROP_VALUT)
      return false
    else
      ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(self.id, comment.id)
      my_rank = ranking.ranking_type_id if ranking
      if my_rank
        if ranking.updated_at < comment.updated_at
          return true
        else
          return false
        end
      else
        return true
      end
    end
  end


  def admin?
    self.user_type.short_name == 'admin'
  end

  def moderator?
    self.user_type.short_name == 'mod'
  end

  #restituisce la richiesta di partecipazione 
  def has_asked_for_partecipation?(group_id)
    self.group_partecipation_requests.find_by_group_id(group_id)
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
    if user
      return user
    else #crea un nuovo account facebook
      if data["verified"]
        user = User.new(:name => data["first_name"], :surname => data["last_name"], :sex => (data["gender"] ? data["gender"][0] : nil), :email => data["email"], :password => Devise.friendly_token[0, 20], :facebook_page_url => data["link"])
        user.user_type_id = 3
        user.sign_in_count = 0
        user.build_authentication_provider(access_token)
        user.confirm!
        user.save(:validate => false)
      else
        return nil
      end
      return user
    end
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
    if user
      return user
    else #crea un nuovo account linkedin
      user = User.new(:name => data["firstName"], :surname => data["lastName"], :email => data["emailAddress"], :password => Devise.friendly_token[0, 20], :blog_image_url => data[:pictureUrl], :linkedin_page_url => data[:publicProfileUrl])
      user.user_type_id = 3
      user.sign_in_count = 0
      user.build_authentication_provider(access_token)
      user.confirm!
      user.save(:validate => false)
      return user
    end
  end


#gestisce l'azione di login tramite google
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] #dati di google
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'])
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    else
      user = User.find_by_email(data['email']) #altrimenti cercane uno con l'email uguale
    end

    if user
      return user
    else #crea un nuovo account google
      user = User.new(:name => data["given_name"], :surname => data["family_name"], :sex => (data["gender"] ? data["gender"][0] : nil), :email => data["email"], :password => Devise.friendly_token[0, 20], :google_page_url => data["link"])
      user.user_type_id = 3
      user.sign_in_count = 0
      user.build_authentication_provider(access_token)
      user.confirm!
      user.save(:validate => false)
      return user
    end
  end


#gestisce l'azione di login tramite twitter
  def self.find_for_twitter(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] #dati di twitter
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'])
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    end

    if user
      return user
    else #crea un nuovo account twitter
      fullname = data["name"]
      splitted = fullname.split(' ', 2)
      name = splitted ? splitted[0] : fullname
      surname = splitted ? splitted[1] : ''
      user = User.new(:name => name, :surname => surname, :password => Devise.friendly_token[0, 20], :blog_image_url => data[:profile_image_url])
      user.user_type_id = 3
      user.sign_in_count = 0
      user.build_authentication_provider(access_token)
      user.confirm!
      user.save(:validate => false)
      return user
    end
  end


#gestisce l'azione di login tramite meetup
  def self.find_for_meetup(access_token, signed_in_resource=nil)
    data = access_token['extra']['raw_info'] #dati di twitter
    auth = Authentication.find_by_provider_and_uid(access_token['provider'], access_token['uid'].to_s)
    if auth
      user = auth.user #se ho trovato l'id dell'utente prendi lui
    end

    if user
      return user
    else #crea un nuovo account twitter
      fullname = data["name"]
      splitted = fullname.split(' ', 2)
      name = splitted ? splitted[0] : fullname
      surname = splitted ? splitted[1] : ''
      user = User.new(:name => name, :surname => surname, :password => Devise.friendly_token[0, 20], :blog_image_url => data[:photo][:photo_link])
      user.user_type_id = 3
      user.sign_in_count = 0
      user.build_authentication_provider(access_token)
      user.confirm!
      user.save(:validate => false)
      return user
    end
  end


  def build_authentication_provider(access_token)
    self.authentications.build(:provider => access_token['provider'], :uid => access_token['uid'], :token => (access_token['credentials']['token'] rescue nil))
  end

  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider(Authentication::FACEBOOK).token).fetch rescue nil
  end


  def fullname
    return "#{self.name} #{self.surname}"
  end


  def to_param
    "#{id}-#{self.fullname.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end


  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(login) = :value OR lower(email) = :value", {:value => login.downcase}]).first
    else
      where(conditions).first
    end
  end

end
