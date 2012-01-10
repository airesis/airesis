class ProposalComment < ActiveRecord::Base
  include BlogKitModelHelper
  include LogicalDeleteHelper

  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal_comments, :class_name => 'ProposalComment', :foreign_key => :parent_proposal_comment_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id, :counter_cache => true
  has_many :rankings, :class_name => 'ProposalCommentRanking', :dependent => :destroy
  
  validates_length_of :content, :minimum => 10, :maximum => 4000
  
  attr_accessor :collapsed
  
  after_initialize :set_collapsed
  
  validate :check_last_comment
  
  def set_collapsed     
     @collapsed = false     
  end
 
  def check_last_comment
    comments =  self.proposal.comments.find_all_by_user_id(self.user_id, :order => "created_at DESC")
    comment = comments.first
    if LIMIT_COMMENTS and comment and (((Time.now - comment.created_at)/60) < 2)
       self.errors.add(:created_at,"Devono passare almeno due minuti tra un commento e l'altro.")
    end
  end
 
 
  
  # Used to set more tracking for akismet
  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end
 
 
 #restituisce il numero di valutazioni che sono state fatte per questo commento
  def valutations
     return self.rankings.count    
  end
  
  #restituisce la valutazione del commento. 0 se non ci sono state valutazioni
  def rank   
    nvalutations = self.valutations
    num_pos = self.rankings.positives.count
    ranking = 0
    res = num_pos.to_f / nvalutations.to_f
    ranking = res*100 if nvalutations > 0
    ranking
    return ranking.round
  end
  
 
end
