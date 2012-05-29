#encoding: utf-8
class Proposal < ActiveRecord::Base
  include BlogKitModelHelper
    
  belongs_to :state, :class_name => 'ProposalState', :foreign_key => :proposal_state_id
  belongs_to :category, :class_name => 'ProposalCategory', :foreign_key => :proposal_category_id
  belongs_to :vote_period, :class_name => 'Event', :foreign_key => :vote_period_id
  has_many :proposal_presentations, :class_name => 'ProposalPresentation', :order => 'id DESC'
  has_many :proposal_borders, :class_name => 'ProposalBorder'
  has_many :proposal_histories, :class_name => 'ProposalHistory'
  #  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_one :vote, :class_name => 'ProposalVote'
  has_many :user_votes, :class_name => 'UserVote'
  has_many :comments, :class_name => 'ProposalComment', :dependent => :destroy
  has_many :rankings, :class_name => 'ProposalRanking', :dependent => :destroy
  has_many :positive_rankings, :class_name => 'ProposalRanking', :conditions => ['ranking_type_id = 1']

  has_many :users, :through => :proposal_presentations, :class_name => 'User'
  
  has_many :proposal_supports, :class_name => 'ProposalSupport', :dependent => :destroy
  has_many :groups, :through => :proposal_supports, :class_name => 'Group'
  #confini di interesse
  has_many :interest_borders,:through => :proposal_borders, :class_name => 'InterestBorder'  
  
  #validation
  validates_presence_of :title, :message => "Il titolo della proposta è obbligatorio" 
  validates_uniqueness_of :title 
  
  validates_presence_of :content
  
  attr_accessor :update_user_id
  
  attr_accessible :proposal_category_id, :content, :title, :interest_borders_tkn, :subtitle, :objectives, :problems
  
  scope :current, { :conditions => {:proposal_state_id => [1,2,3,4] }}
  scope :accepted, { :conditions => {:proposal_state_id => 6 }}
  
  #default_scope :include => [:positive_rankings]
  
#  after_save :reset_cache
  
 # def reset_cache
 # @user = nil
 #end
 after_update :save_proposal_history
 
 #prima di aggiornare la proposta salvane la 
 #storia nella tabella dedicata (se è cambiato il testo)
 def save_proposal_history
   if self.content_changed? || self.problem_changed?
     puts "Updated!"
     history = ProposalHistory.new
     history.proposal_id = self.id
     history.user_id = self.update_user_id
     history.content = self.content_was
     history.problem = self.problem_was
     history.valutations = self.valutations_was
     history.rank = self.rank_was
     history.save
   end
 end
  
  #restituisce il primo autore della proposta
  def user
    @first_user ||= self.proposal_presentations.first.user
    #@first_user ||= self.proposals_presentations. 
    return @first_user
  end
    
  def short_content
    return truncate_words(self.content,60)
  end
  
  def interest_borders_tkn
    
  end
  
  def interest_borders_tkn=(list)
    
  end

  def partecipants
    return User.all(:joins => {:proposal_rankings =>[:proposal]}, :conditions => ["proposals.id = ?", self.id])
  end
  
end
