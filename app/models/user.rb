require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :omniauthable, #:reconfirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include BlogKitModelHelper, TutorialAssigneesHelper
  #include Rails.application.routes.url_helpers
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => AuthenticationModule.login_regex, :message => AuthenticationModule.bad_login_message
  
  validates_presence_of     :name
  validates_format_of       :name,     :with => AuthenticationModule.name_regex, :allow_nil => true
  validates_length_of       :name,     :maximum => 50
  
  validates_format_of       :surname,     :with => AuthenticationModule.name_regex, :allow_nil => true
  validates_length_of       :surname,     :maximum => 50
  
  validates_length_of       :email,    :within => 6..50 #r@a.wk
  validates_format_of       :email,    :with => AuthenticationModule.email_regex, :message => AuthenticationModule.bad_email_message

  validates_acceptance_of   :accept_conditions, :message => "E' necessario accettare le condizioni d'uso"
  
  #colonne assegnabili massivamente
  attr_accessible :login, :name, :email, :surname, :password, :password_confirmation, :blog_image_url, :sex, :remember_me, :accept_conditions
  
  #relations
  has_many :proposal_presentations, :class_name => 'ProposalPresentation'
  has_many :proposals, :through => :proposal_presentations, :class_name => 'Proposal'
  has_many :notifications, :through => :user_alerts, :class_name => 'Notification'
  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_many :meeting_partecipations, :class_name => 'MeetingPartecipation'
  has_one  :blog, :class_name => 'Blog'
  has_many :blog_comments, :class_name => 'BlogComment'
  has_many :blog_posts, :class_name => 'BlogPost'
  has_many :blocked_alerts, :class_name => 'BlockedAlert'
  has_many :group_partecipations, :class_name => 'GroupPartecipation'
  
  has_many :groups,:through => :group_partecipations, :class_name => 'Group'  
  
  has_many :partecipation_roles,:through => :group_partecipations, :class_name => 'PartecipationRole'  
  has_many :group_follows, :class_name => 'GroupFollow'
  has_many :followed_groups,:through => :group_follows, :class_name => 'Group'
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
  has_many :interest_borders,:through => :user_borders, :class_name => 'InterestBorder'  
  
  has_many :user_alerts, :class_name => 'UserAlert', :order => 'created_at DESC'
  has_many :blocked_notifications, :through => :blocked_alerts, :class_name => 'NotificationType', :source => :notification_type
  
  has_many :group_partecipation_requests, :class_name => 'GroupPartecipationRequest'

  #record di tutti coloro che mi seguono
  has_many :followers_user_follow, :class_name => "UserFollow", :foreign_key => :followed_id  
  #tutti coloro che mi seguono
  has_many :followers,:through => :followers_user_follow, :class_name => "User", :source => :followed
  
  #record di tutti coloro che seguo
  has_many :followed_user_follow, :class_name => "UserFollow", :foreign_key => :follower_id  
  #tutti coloro che seguo
  has_many :followed,:through => :followed_user_follow, :class_name => "User", :source => :follower
  
  has_many :tutorial_assignees, :class_name => 'TutorialAssignee'
  has_many :tutorial_progresses, :class_name => 'TutorialProgress'
  has_many :todo_tutorial_assignees, :class_name => 'TutorialAssignee', :conditions => 'tutorial_assignees.completed = false'
  #tutorial assegnati all'utente
  has_many :tutorials, :through => :tutorial_assignees, :class_name => 'Tutorial', :source => :user
  has_many :todo_tutorials, :through => :todo_tutorial_assignees, :class_name => 'Tutorial', :source => :user
  
  
  #affinità con i gruppi
  has_many :group_affinities, :class_name => 'GroupAffinity'
  
  has_many :suggested_groups, :through => :group_affinities, :class_name => "Group", :order => "group_affinities.value desc", :limit => 10, :source => :group
  
  
  
  #fake columns
  attr_accessor :image_url, :accept_conditions

  before_create :init
  
  after_create :assign_tutorials
  
  #dopo aver creato un nuovo utente glia ssegno il primo tutorial
  def assign_tutorials
    tutorial = Tutorial::WELCOME
    assign_tutorial(self,tutorial)      
  end

  def init
    self.rank  ||= 0 #imposta il rank a zero se non è valorizzato     
  end


 #restituisce l'elenco delle partecipazioni ai gruppi dell'utente
 #all'interno dei quali possiede un determinato permesso
 def scoped_group_partecipations(abilitation)
   return self.group_partecipations.joins(" INNER JOIN partecipation_roles ON partecipation_roles.id = group_partecipations.partecipation_role_id"+
                                   " LEFT JOIN action_abilitations ON action_abilitations.partecipation_role_id = partecipation_roles.id "+
                                   " and action_abilitations.group_id = group_partecipations.group_id")
                                   .find(:all, 
                                         :conditions => "(partecipation_roles.name = 'portavoce' or action_abilitations.group_action_id = " + abilitation.to_s + ")")
 end

 def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
  def last_blog_comment
    self.blog_comments
  end
  
  
  def image_url
    if (self.blog_image_url != nil)
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
  
  def email=(value)
    if (self.account_type != 'facebook')
      write_attribute :email, (value ? value.downcase : nil)
    end
  end
  
  #determina se un oggetto appartiene all'utente verificando che 
  #l'oggetto abbia un campo user_id corrispondente all'id dell'utente
  #in caso contrario verifica se l'oggetto ha un elenco di utenti collegati 
  #e proprietari, in caso affermativo verifica di rientrare tra questi.
  def is_mine? object
    if (object)
      if (object.respond_to?('user_id'))
        if (object.user_id == self.id)
          return true
        else
          return false
        end
      elsif (object.respond_to?('users'))
        if (object.users.find_by_id(self.id))
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end

  #questo metodo prende in input l'id di una proposta e verifica che l'utente ne sia l'autore
  def is_my_proposal? proposal_id
    proposal = self.proposals.find_by_id(proposal_id) #cerca tra le mie proposte quella con id 'proposal_id'
    if (proposal) #se l'ho trovata allora è mia
      true
    else
      false
    end
  end
  
   #questo metodo prende in input l'id di una proposta e verifica che l'utente ne sia l'autore
  def is_my_blog_post? blog_post_id
    blog_post = self.blog_posts.find_by_id(blog_post_id) #cerca tra le mie proposte quella con id 'proposal_id'
    if (blog_post) #se l'ho trovata allora è mia
      true
    else
      false
    end
  end
  
  #questo metodo prende in input l'id di un blog e verifica che appartenga all'utente
  def is_my_blog? blog_id    
    if (self.blog and self.blog.id == blog_id)
      true
    else
      false
    end
  end
  
  def has_ranked_proposal? proposal_id
    ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id,proposal_id)
    if ranking
      return true
    else
      return false
    end
  end
  
  #restituisce il voto che l'utente ha dato ad un determinato commento
  #se l'ha dato. nil altrimenti
  def comment_rank(comment)
    ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(self.id,comment.id)
    if ranking
      return ranking.ranking_type_id
    else
      return nil
    end
  end
  
  #restituisce true se l'utente ha valutato un commento
  #ma il commento è stato successivamente modificato e può quindi valutarlo di nuovo 
  def can_rank_again_comment?(comment)
    if (comment.proposal.proposal_state_id != PROP_VALUT)
      return false
    else
      ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(self.id,comment.id)
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
    if (self.user_type.short_name == 'admin')
      return true
    else
      return false
    end
  end
  
  #restituisce la richiesta di partecipazione 
  def has_asked_for_partecipation?(group_id)
   request = self.group_partecipation_requests.find_by_group_id(group_id)
   return request
 end
 

#gestisce l'azione di login tramite facebook
def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
  data = access_token['extra']['raw_info'] ##dati di facebook
  #se è presente un account facebook per l'utente usa quello
  if user = User.find_by_email_and_account_type(data["email"],'facebook')
    return user
  elsif user = User.find_by_email(data["email"])  #se è presente un account sul portale richiedine le credenziali per effettuarne il merge
      return user      
  else  #crea un nuovo account facebook
    if data["verified"]
      user = User.create(:confirmation_token => '', :name => data["first_name"], :surname => data["last_name"], :sex => data["gender"][0],  :email => data["email"], :password => Devise.friendly_token[0,20])
      user.user_type_id = 3
      user.sign_in_count = 0
      user.account_type = 'facebook'     
      user.authentications.build(:provider => access_token['provider'], :uid => access_token['uid'], :token =>(access_token['credentials']['token'] rescue nil))
      user.confirm!
      user.save(:validate => false)
    else
      return nil
    end 
    return user
  end
end

def facebook
  
  @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token).fetch rescue nil
end

end
