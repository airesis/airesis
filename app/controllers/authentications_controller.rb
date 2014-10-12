#encoding: utf-8
class AuthenticationsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user

  def destroy
    @authentication.destroy
    flash[:notice] = t('info.user.IP_disabled')
    redirect_to privacy_preferences_users_url
  end
end
