class IntegratedContribute < ActiveRecord::Base
  belongs_to :proposal_revision, inverse_of: :integrated_contributes
  belongs_to :proposal_comment, inverse_of: :integrated_contribute

  after_commit :send_notifications, on: :destroy

  protected

  def send_notifications
    NotificationProposalCommentUnintegrate.perform_async(proposal_comment.id)
  end
end
