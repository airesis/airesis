class ProposalPresentation < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id


  after_commit :send_notifications, on: :create

  protected

  def send_notifications
    NotificationProposalPresentationCreate.perform_async(id)
  end
end
