# invite other users in the group
class GroupInvitationsController < ApplicationController
  layout 'groups'

  load_and_authorize_resource :group
  load_and_authorize_resource through: :group

  def new
    respond_to do |format|
      format.html do
        @page_title = t('pages.groups.invite_your_friends.title')
      end
      format.js
    end
  end

  def create
    @group_invitation.inviter = current_user
    @group_invitation.save!

    respond_to do |format|
      if @group_invitation.group_invitation_emails.any?
        flash[:notice] = t('info.group_invitations.create',
                           count: @group_invitation.group_invitation_emails.count,
                           email_addresses: @group_invitation.group_invitation_emails.pluck(:email).join(', '))
      else
        flash[:error] = t('error.group_invitations.create')
      end
      format.js
      format.html { redirect_to @group }
    end
  end

  protected

  def group_invitation_params
    params.require(:group_invitation).permit(:emails_list, :testo)
  end
end
