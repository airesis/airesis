module Admin
  class UsersController < Admin::ApplicationController
    include UsersHelper

    def block
      @user = User.find_by(id: params[:user_id])
      @user = User.find_by(email: params[:user_id]) unless @user
      if @user && !@user.blocked
        @user.blocked = true
        @user.blocked_name = @user.name
        @user.blocked_surname = @user.surname
        @user.avatar = nil
        @user.name = 'Utente'
        @user.surname = 'Eliminato'
        @user.save!
      end
      flash[:notice] = t('info.moderator_panel.account_blocked')
      ResqueMailer.delay.blocked(@user.id)
      redirect_to :back
    end

    def unblock
      @user = User.find(params[:id])
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

    # admin user autocomplete
    def autocomplete
      users = User.autocomplete(params[:term])
      users = users.map do |u|
        {id: u.id, identifier: "#{u.surname} #{u.name}", name: "#{u.name}", surname: "#{u.surname}", image_path: "#{avatar(u, size: 20)}"}
      end
      render json: users
    end

  end
end
