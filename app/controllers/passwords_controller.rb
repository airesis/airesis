class PasswordsController < Devise::PasswordsController
  def create
    if params[:user] && params[:user][:login]
      user = User.where(['(login = :login or email = :login) and users.blocked = false', login: params[:user][:login]]).first
      if user
        super
      else
        @user = User.new
        flash[:error] = t('error.registration.user_not_found')
        render :new
      end
    end
  end
end
