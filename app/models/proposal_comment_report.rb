class ProposalCommentReport < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal_comment_report_type
  belongs_to :proposal_comment

  scope :softs, {:joins => :proposal_comment_report_type, :conditions => {:severity => ProposalCommentReportType::LOW}}
  scope :graves, {:joins => :proposal_comment_report_type, :conditions => {:severity => ProposalCommentReportType::HIGH}}

  after_save :increase_counter_cache
  after_destroy :decrease_counter_cache

  def increase_counter_cache
    self.proposal_comment_report_type.severity == ProposalCommentReportType::LOW ?
        self.proposal_comment.increment!(:soft_reports_count) :
        self.proposal_comment.increment!(:grave_reports_count)
  end

  def decrease_counter_cache
    self.proposal_comment_report_type.severity == ProposalCommentReportType::LOW ?
        self.proposal_comment.decrement!(:soft_reports_count) :
        self.proposal_comment.decrement!(:grave_reports_count)
  end

end
