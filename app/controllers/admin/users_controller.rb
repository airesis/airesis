module Admin
  class UsersController < Admin::ApplicationController
    include UsersHelper

    def block
      @user = User.find_by(id: params[:user_id])
      @user ||= User.find_by(email: params[:user_id])
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
      redirect_back(fallback_location: root_path)
    end

    def unblock
      @user = User.find(params[:id])
      if @user&.blocked
        @user.blocked = false
        @user.name = @user.blocked_name
        @user.surname = @user.blocked_surname
        @user.blocked_name = nil
        @user.blocked_surname = nil
        @user.save!
      end
      flash[:notice] = t('info.moderator_panel.account_unblocked')
      redirect_back(fallback_location: root_path)
    end

    # admin user autocomplete
    def autocomplete
      users = User.autocomplete(params[:term])
      users = users.map do |u|
        { id: u.id, identifier: "#{u.surname} #{u.name}", name: u.name.to_s, surname: u.surname.to_s, image_path: avatar(u, size: 20).to_s }
      end
      render json: users
    end
  end
end
