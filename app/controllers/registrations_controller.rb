class RegistrationsController < Devise::RegistrationsController
  def create
    session[:remote_ip] = request.remote_ip
    if session[:omniauth].nil?
      if !::Configuration.recaptcha || verify_recaptcha
        super
        session[:omniauth] = nil unless @user.new_record?
      else
        build_resource
        clean_up_passwords(resource)
        flash[:alert] = t('error.registration.recaptcha')
        render :new
      end
    else
      super
      session[:omniauth] = nil unless @user.new_record? # OmniAuth
    end
  end

  protected

  def after_sign_up_path_for(_resource)
    if session[:invite]
      session[:invite]['return']
    else
      new_user_session_path
    end
  end

  def after_inactive_sign_up_path_for(_resource)
    new_user_session_path
  end
end
