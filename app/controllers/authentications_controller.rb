#encoding: utf-8
#todo refactor this class and security checks
class AuthenticationsController < ApplicationController
  before_filter :load_user

  before_filter :load_auth

  #user must be logged in
  before_filter :authenticate_user!

  def destroy
    authorize! :destroy, @authentication
    @authentication.destroy
    flash[:notice] = t('info.user.IP_disabled')
    redirect_to privacy_preferences_users_url
  end

  protected

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_auth
    @authentication = Authentication.find(params[:id])
  end
end
