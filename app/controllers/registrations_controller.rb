class RegistrationsController < Devise::RegistrationsController

  def create
    if session[:omniauth] == nil
      if !::Configuration.recaptcha || verify_recaptcha
        super
        session[:omniauth] = nil unless @user.new_record?
      else
        build_resource
        clean_up_passwords(resource)
        flash[:alert] = t('controllers.registrations.create.recaptcha_ko')
        render :new
      end
    else
      super
      session[:omniauth] = nil unless @user.new_record? #OmniAuth
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if session[:invite]
      ret = session[:invite][:return]
      ret
    else
      '/users/sign_in'
    end
  end

  def after_inactive_sign_up_path_for(resource)
    '/users/sign_in'
  end




end
