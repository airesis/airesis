class ProposalComment < ActiveRecord::Base
  include BlogKitModelHelper
  include LogicalDeleteHelper

  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :contribute, :class_name => 'ProposalComment', :foreign_key => :parent_proposal_comment_id
  has_many :replies, :class_name => 'ProposalComment', :foreign_key => :parent_proposal_comment_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id, :counter_cache => true
  has_many :rankings, :class_name => 'ProposalCommentRanking', :dependent => :destroy
  
  validates_length_of :content, :minimum => 10, :maximum => CONTRIBUTE_MAX_LENGTH
  
  attr_accessor :collapsed
  
  after_initialize :set_collapsed
  
  validate :check_last_comment
  
  def set_collapsed     
     @collapsed = false     
  end
 
  def check_last_comment
    comments =  self.proposal.comments.find_all_by_user_id(self.user_id, :order => "created_at DESC")
    comment = comments.first
    if LIMIT_COMMENTS and comment and ((Time.now - comment.created_at) < 30)
       self.errors.add(:created_at,"Devono passare almeno trenta secondi tra un commento e l'altro.")
    end
  end
 
 
  
  # Used to set more tracking for akismet
  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end  
 
end
