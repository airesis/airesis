class ProposalPresentation < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :acceptor, class_name: 'User', foreign_key: :acceptor_id
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id

  before_create :generate_nickname

  after_commit :send_notifications, on: :create, unless: :skip_notifications?

  protected

  def skip_notifications?
    acceptor.nil?
  end

  def generate_nickname
    ProposalNickname.generate(user, proposal)
  end

  def send_notifications
    NotificationProposalPresentationCreate.perform_async(id)
  end
end
