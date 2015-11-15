class PasswordsController < Devise::PasswordsController
  def create
    if params[:user] && params[:user][:email]
      user = User.find_first_by_auth_conditions(params[:user])
      if user && !user.blocked?
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

