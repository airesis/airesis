# manage invitations responses
class GroupInvitationEmailsController < ApplicationController

  load_and_authorize_resource :group
  load_and_authorize_resource :group_invitation, through: :group
  load_and_authorize_resource through: :group_invitation, id_param: :token, find_by: :token

  before_filter :authenticate_user_from_invite!, only: [:accept]

  before_filter :check_invite, only: [:accept, :reject, :anymore]

  # accept invite from email link
  def accept
    @group_invitation_email.user_id = current_user.id
    @group_invitation_email.accept
    flash[:notice] = t('info.group_invitations.accept')
    redirect_to @group
  end

  # reject an invite from email
  def reject
    @group_invitation_email.user_id = current_user.try(:id)
    @group_invitation_email.reject

    flash[:notice] = t('info.group_invitations.reject')
    redirect_to @group
  end

  # nomore invitations from no-one
  def anymore
    @group_invitation_email.user_id = current_user.try(:id)
    @group_invitation_email.anymore

    flash[:notice] = t('info.group_invitations.anymore')
    redirect_to @group
  end

  protected

  def check_invite
    if @group_invitation_email.consumed
      flash[:error] = t('error.group_invitations.code_expired')
      redirect_to @group
      false
    elsif @group.participants.include? current_user
      flash[:error] = t('error.group_invitations.already_participant')
      redirect_to @group
      false
    end
  end

  def authenticate_user_from_invite!
    return if user_signed_in?
    session[:user_return_to] = request.url
    session[:user] = {}
    session[:user][:email] = params[:email]
    session[:invite] = { email: params[:email], token: params[:token], group_id: @group.id, return: request.url }
    if User.where(email: params[:email]).exists?
      redirect_to new_user_session_path(invite: params[:token], user: { login: params[:email] })
    else
      redirect_to new_user_registration_path(invite: params[:token])
    end
  end
end
