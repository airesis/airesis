class  IntegratedContribute < ActiveRecord::Base
  belongs_to :proposal_revision
  belongs_to :proposal_comment

  after_commit :send_notifications, on: :destroy

  protected

  def send_notifications
    NotificationProposalCommentUnintegrate.perform_async(proposal_comment.id)
  end
end
