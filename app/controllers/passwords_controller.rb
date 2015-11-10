class PasswordsController < Devise::PasswordsController
  def create
    if params[:user] && params[:user][:email]
      user = User.where(email: params[:user][:email], blocked: false).first
      if user
        super
      else
        @user = User.new
        flash[:error] = t('error.registration.user_not_found')
        render :new
      end
    end
  end

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_user_session_path
  end
end

