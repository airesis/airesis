#encoding: utf-8
class Proposal < ActiveRecord::Base
  include BlogKitModelHelper
  
  
  belongs_to :state, :class_name => 'ProposalState', :foreign_key => :proposal_state_id
  belongs_to :category, :class_name => 'ProposalCategory', :foreign_key => :proposal_category_id
  belongs_to :vote_period, :class_name => 'Event', :foreign_key => :vote_period_id
  has_many :proposal_presentations, :class_name => 'ProposalPresentation', :order => 'id DESC'
  #  has_many :proposal_watches, :class_name => 'ProposalWatch'
  has_one :vote, :class_name => 'ProposalVote'
  has_many :user_votes, :class_name => 'UserVote'
  has_many :comments, :class_name => 'ProposalComment', :dependent => :destroy
  has_many :rankings, :class_name => 'ProposalRanking', :dependent => :destroy
  has_many :positive_rankings, :class_name => 'ProposalRanking', :conditions => ['ranking_type_id = 1']

  has_many :users, :through => :proposal_presentations, :class_name => 'User' 
  
  #validation
  validates_presence_of :title, :message => "Il titolo della proposta è obbligatorio" 
  validates_uniqueness_of :title 
  
  attr_accessible :proposal_category_id, :content, :title
  
  scope :current, { :conditions => {:proposal_state_id => [1,2,3,4] }}
  scope :accepted, { :conditions => {:proposal_state_id => 6 }}
  
  default_scope :include => [:positive_rankings]
  
#  after_save :reset_cache
  
 # def reset_cache
 # @user = nil
 #end
  
  #restituisce il primo autore della proposta
  def user
    @first_user ||= self.proposal_presentations.first.user
    #@first_user ||= self.proposals_presentations. 
    return @first_user
  end
  
  #restituisce il numero di valutazioni che sono state fatte alla proposta
  def valutations
    return self.proposal_rankings_count
  end
  
  #restituisce la valutazione della proposta. 0 se non ci sono state valutazioni
  def rank 
     nvalutations = self.valutations
     num_pos = self.positive_rankings.count
     ranking = 0
     res = num_pos.to_f / nvalutations.to_f
     ranking = res*100 if nvalutations > 0
    return ranking.round
  end
  
  def short_content
    return truncate_words(self.content,50)
  end
end
