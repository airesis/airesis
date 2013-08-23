#encoding: utf-8
class PasswordsController < Devise::PasswordsController
  def create
    if params[:user] && params[:user][:login]
      user = User.where(['(login = :login or email = :login) and users.blocked = false', login: params[:user][:login]]).first
      if user
        super
      else
        @user = User.new
        @user.errors.add(:blocked,"Utente non trovato, spiacenti")
        render :new
      end
    end
  end
end
