class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    '/users/sign_in'
  end

  def after_inactive_sign_up_path_for(resource)
    '/users/sign_in'
  end

end
