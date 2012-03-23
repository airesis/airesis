class SessionsController < Devise::SessionsController

protected

  def after_sign_in_path_for(resource)
    if resource.banned?
      sign_out resource
      flash[:error] = "Account momentaneamente sospeso"
      root_path
    else
      super
    end
   end

end
