require 'digest/sha1'

class User < ActiveRecord::Base
  include BlogKitModelHelper
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  include Authorization::StatefulRoles
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name,:surname, :password, :password_confirmation, :blog_image_url
  
  #relations
  has_many :proposal_presentations, :class_name => 'ProposalPresentation'
  has_many :proposals, :through => :proposal_presentations, :class_name => 'Proposal'
  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_many :meetings_partecipations, :class_name => 'MeetingsPartecipation'
  has_one  :blog, :class_name => 'Blog'
  has_many :blog_comments, :class_name => 'BlogComment'
  has_many :blog_posts, :class_name => 'BlogPost'
  has_many :group_partecipations, :class_name => 'GroupPartecipation'
  has_many :groups,:through => :group_partecipations, :class_name => 'Group'  
  has_many :group_follows, :class_name => 'GroupFollow'
  has_many :following,:through => :group_follows, :class_name => 'Group'
  has_many :user_votes, :class_name => 'UserVote'
  has_many :proposal_comments, :class_name => 'ProposalComment'
  has_many :proposal_comment_rankings, :class_name => 'ProposalCommentRanking'
  has_many :proposal_rankings, :class_name => 'ProposalRanking'
  belongs_to :user_type, :class_name => 'UserType', :foreign_key => :user_type_id
  belongs_to :places, :class_name => 'Place', :foreign_key => :residenza_id
  belongs_to :places, :class_name => 'Place', :foreign_key => :nascita_id
  belongs_to :image, :class_name => 'Image', :foreign_key => :image_id
  
  
  has_many :group_partecipation_requests, :class_name => 'GroupPartecipationRequest'

  attr_accessor :image_url

  
  def last_blog_comment
    self.blog_comments
  end
  
  
  def image_url
    if (self.image)
      return self.image.image.url
    elsif (self.blog_image_url != nil)
      return self.blog_image_url
    else
      return ""      
    end
  end
  
  
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  
  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  
  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
  end  
  
  #used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end
  
  def recently_reset_password?
    @reset_password
  end
  
  def recently_activated?
    @recent_active
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
 
  def link_to_page(skip_link=false)
    if !skip_link
      return "<a href=\"/users/#{self.id}\">#{CGI.escapeHTML(self.name)}</a>"
    else
      return self.name
    end
  end
  
  def full_link_to_page(skip_link=false)
    if !skip_link
      return "<a class='full_link' href=\"/users/#{self.id}\">#{CGI.escapeHTML(self.name)} #{CGI.escapeHTML(self.surname)}</a>"
    else
      return self.name
    end
  end

  
  protected
  def make_activation_code
    
    self.deleted_at = nil
    
    self.activation_code = self.class.make_token
  end
  
  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  
  
  
end
