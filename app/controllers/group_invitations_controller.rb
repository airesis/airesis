# invite other users in the group
class GroupInvitationsController < ApplicationController

  load_and_authorize_resource :group
  load_and_authorize_resource through: :group

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @group_invitation.inviter_id = current_user.id
    @group_invitation.save

    respond_to do |format|
      flash[:notice] = t('info.group_invitations.create')
      format.js
    end
  end

  protected

  def group_invitation_params
    params.require(:group_invitation).permit(:emails_list)
  end
end
