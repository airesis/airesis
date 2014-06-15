class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    super
  end
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
