#encoding: utf-8

class ManagerController < ApplicationController

  def block
    @user = User.find_by_id(params[:user_id])
    @user = User.find_by_email(params[:user_id]) unless @user
    if @user && !@user.blocked
      @user.blocked = true
      @user.blocked_name = @user.name
      @user.blocked_surname = @user.surname
      @user.name = 'Utente'
      @user.surname = 'Eliminato'
      @user.save!
    end
    flash[:notice] = t('info.moderator_panel.account_blocked')
    ResqueMailer.blocked(@user.id).deliver
    redirect_to :back
  end

  def unblock
    @user = User.find_by_id(params[:user_id])
    @user = User.find_by_email(params[:user_id]) unless @user
    if @user && @user.blocked
      @user.blocked = false
      @user.name = @user.blocked_name
      @user.surname = @user.blocked_surname
      @user.blocked_name = nil
      @user.blocked_surname = nil
      @user.save!
    end
    flash[:notice] = t('info.moderator_panel.account_unblocked')
    redirect_to :back
  end
end
