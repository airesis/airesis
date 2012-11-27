class Devise::RegistrationsController < DeviseController

  protected
  #redirect alla pagina delle proposte
  def after_sign_up_path_for(resource)
    '/users/sign_in' # <- Path you want to redirect the user to.
  end

  def after_inactive_sign_up_path_for(resource)
    '/users/sign_in'
  end
end
