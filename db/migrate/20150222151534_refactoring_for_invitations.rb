class RefactoringForInvitations < ActiveRecord::Migration
  def change
    add_column :group_invitation_emails, :token, :string, limit: 32
    add_column :group_invitation_emails, :consumed, :boolean, default: false
    add_column :group_invitation_emails, :user_id, :integer
    add_column :group_invitation_emails, :group_invitation_id, :integer
    add_column :group_invitations, :group_id, :integer
    GroupInvitation.find_each do |group_invitation|
      group_invitation_email = GroupInvitationEmail.find_by(id: group_invitation.group_invitation_email_id)
      next unless group_invitation_email
      group_invitation_email.token = group_invitation.token
      group_invitation_email.consumed = group_invitation.consumed
      group_invitation_email.group_invitation_id = group_invitation.id
      group_invitation_email.user_id = group_invitation.invited_id
      group_invitation.group_id = group_invitation_email.group_id
      group_invitation.save!
      group_invitation_email.save!
    end

    remove_column :group_invitations, :group_invitation_email_id
    remove_column :group_invitations, :invited_id

  end
end
