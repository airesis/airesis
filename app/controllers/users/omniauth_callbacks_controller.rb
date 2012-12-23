#encoding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user
      #se all'utente è già collegato un account facebook
      if @user.has_provider(Authentication::FACEBOOK)
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in_and_redirect @user, :event => :authentication
      elsif @user.from_identity_provider?
        flash[:error] = "Esiste già un altro account con questo indirizzo email."
        redirect_to new_user_session_path
      else  
        session["devise.facebook_data"] = env["omniauth.auth"]
        redirect_to confirm_credentials_users_url
      end
    else
      flash[:error] = "Account facebook non verificato."
      redirect_to proposals_path
    end
  end
  
  def google_oauth2
      @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
      if @user
        #se all'utente è già collegato un account google
        if @user.has_provider(Authentication::GOOGLE)
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
          sign_in_and_redirect @user, :event => :authentication
        elsif @user.from_identity_provider?
          flash[:error] = "Esiste già un altro account con questo indirizzo email."
          redirect_to new_user_session_path  
        else        
          session["devise.google_data"] = request.env["omniauth.auth"]
          redirect_to confirm_credentials_users_url
        end
      else
        flash[:error] = "Account Google non verificato."
        redirect_to proposals_path
      end  
  end

  def passthru
    render_404
  end
end