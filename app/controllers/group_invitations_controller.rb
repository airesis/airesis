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
    @group_invitation.inviter_id = current_user.id
    @group_invitation.save

    respond_to do |format|
      flash[:notice] = t('info.group_invitations.create',
                         count: @group_invitation.group_invitation_emails.count,
                         email_addresses: @group_invitation.group_invitation_emails.pluck(:email).join(', '))
      format.js
      format.html { redirect_to @group }
    end
  end

  protected

  def group_invitation_params
    params.require(:group_invitation).permit(:emails_list, :testo)
  end
end
