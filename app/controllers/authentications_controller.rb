class AuthenticationsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user

  def destroy
    if @authentication.destroy
      flash[:notice] = t('info.user.IP_disabled')
    else
      flash[:error] = t('error.permissions_required')
    end
    redirect_to privacy_preferences_users_url
  end
end
