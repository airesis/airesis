class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if (@user)
      if (@user.account_type == 'facebook')
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.facebook_data"] = env["omniauth.auth"]
        redirect_to confirm_credentials_users_url
      end
    else
      flash[:error] = "Account facebook non verificato."
      redirect_to proposals_path
    end
  end

  def google_apps
    @user = User.find_for_google_apps_oauth(env["omniauth.auth"], current_user)

    if @user.persisted?
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google Apps"
    sign_in_and_redirect @user, :event => :authentication
    else
    session["devise.google_apps_data"] = env["omniauth.auth"]
    redirect_to new_user_registration_url
    end
  end

  def passthru
    render_404
  end
end