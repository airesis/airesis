class GroupInvitationEmail < ActiveRecord::Base

  belongs_to :group_invitation
  belongs_to :invited, class_name: 'User', foreign_key: :user_id

  before_create :generate_token

  after_commit :send_emails, on: :create

  def accept
    self.consumed = true
    self.accepted = 'Y'
    group_invitation.group.participation_requests.create(user: invited, group_participation_request_status_id: GroupParticipationRequestStatus::ACCEPTED)
    group_invitation.group.group_participations.create(user: invited, participation_role: group_invitation.group.default_role)
    save
  end

  def reject
      self.consumed = true
      self.accepted = 'N'
      save
  end

  def anymore
    reject
    BannedEmail.create(email: email)
  end

  protected

  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while GroupInvitationEmail.where(token: token).exists?
    self.token = token
  end

  def send_emails
    ResqueMailer.invite(id).deliver_later
  end

end
