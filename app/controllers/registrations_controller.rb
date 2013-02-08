class RegistrationsController < Devise::RegistrationsController

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
