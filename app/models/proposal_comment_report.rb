# the report of a user about a comment
class ProposalCommentReport < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal_comment_report_type
  belongs_to :proposal_comment

  scope :softs, -> { joins(:proposal_comment_report_type).where(severity: ProposalCommentReportType::LOW) }
  scope :graves, -> { joins(:proposal_comment_report_type).where(severity: ProposalCommentReportType::HIGH) }

  after_save :increase_counter_cache
  after_destroy :decrease_counter_cache

  def increase_counter_cache
    if proposal_comment_report_type.severity == ProposalCommentReportType::LOW
      proposal_comment.increment!(:soft_reports_count)
    else
      proposal_comment.increment!(:grave_reports_count)
      ResqueMailer.report_message(id).deliver_later
    end
  end

  def decrease_counter_cache
    if proposal_comment_report_type.severity == ProposalCommentReportType::LOW
      proposal_comment.decrement!(:soft_reports_count)
    else
      proposal_comment.decrement!(:grave_reports_count)
    end
  end
end
