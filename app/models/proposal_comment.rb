class ProposalComment < ActiveRecord::Base
  include BlogKitModelHelper
  include LogicalDeleteHelper
  include ActionView::Helpers::TextHelper

  has_paper_trail :class_name => 'ProposalCommentVersion', only: [:content], on: [:update,:destroy]


  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :contribute, :class_name => 'ProposalComment', :foreign_key => :parent_proposal_comment_id
  has_many :replies, :class_name => 'ProposalComment', :foreign_key => :parent_proposal_comment_id, dependent: :destroy
  has_many :repliers, class_name: 'User', :through => :replies, :source => :user, uniq: true
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id, :counter_cache => true
  has_many :rankings, :class_name => 'ProposalCommentRanking', :dependent => :destroy
  has_many :rankers, :through => :rankings, :class_name => 'User', source: :user
  belongs_to :paragraph

  has_one :integrated_contribute, :class_name => 'IntegratedContribute', dependent: :destroy
  has_many :proposal_revisions, :class_name => 'ProposalRevision', :through => :integrated_contributes

  has_many :reports, :class_name => 'ProposalCommentReport', :foreign_key => :proposal_comment_id

  validates_length_of :content, :minimum => 10, :maximum => CONTRIBUTE_MAX_LENGTH

  attr_accessor :collapsed

  after_initialize :set_collapsed

  validate :check_last_comment

  scope :contributes, {:conditions => ['parent_proposal_comment_id is null']}
  scope :comments, {:conditions => ['parent_proposal_comment_id is not null']}

  scope :unintegrated, {:conditions => {:integrated => false}}
  scope :integrated, {:conditions => {:integrated => true}}

  scope :noise, {:conditions => {:noise => true}}

  scope :listable, {:conditions => {:integrated => false, :noise => false}}

  scope :unread, lambda { |user_id, proposal_id| {:conditions => ["proposal_comments.id not in (select p2.id from proposal_comments p2 join proposal_comment_rankings pr on p2.id = pr.proposal_comment_id where pr.user_id = ? and p2.proposal_id = ?) ", user_id, proposal_id]} }

  scope :removable, {:conditions => ['soft_reports_count >= ? and noise = false', CONTRIBUTE_MARKS]}

  #a contribute marked more than three times as spam
  scope :spam, {:conditions => ['grave_reports_count >= ?', CONTRIBUTE_MARKS]}

  #a contribute marked more than three times as noisy
  scope :noisy, {:conditions => ['soft_reports_count >= ?', CONTRIBUTE_MARKS]}

  attr_accessor :section_id

  before_create :set_paragraph_id

  def is_contribute?
    self.parent_proposal_comment_id.nil?
  end

  def set_paragraph_id
    self.paragraph = Paragraph.first(:conditions => {:section_id => self.section_id})

  end

  def set_collapsed
    @collapsed = false
  end

  def check_last_comment
    comments = self.proposal.comments.find_all_by_user_id(self.user_id, :order => "created_at DESC")
    comment = comments.first
    if LIMIT_COMMENTS and comment and ((Time.now - comment.created_at) < 30.seconds)
      self.errors.add(:created_at, "devono passare almeno trenta secondi tra un commento e l'altro.")
    end
  end

  # Used to set more tracking for akismet
  def request=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = truncate(request.env['HTTP_REFERER'], length: 255)
  end

  #retrieve all the partecipants to this discussion
  def partecipants
    self.repliers | [self.user]
  end

  def has_location?
    !self.paragraph.nil?
  end

  def location
    ret = nil
    unless self.paragraph.nil?
      section = self.paragraph.section
      ret = section.title
      unless section.solution.nil?
        ret = section.solution.title + " > " + ret
      end
    end
    ret
  end

end
