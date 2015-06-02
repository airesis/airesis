#encoding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  oauth_providers = [:facebook, :google_oauth2, :twitter, :meetup, :parma, :tecnologiedemocratiche, :linkedin]
  oauth_providers.each do |provider|
      define_method(provider) { manage_oauth_callback }
  end

  def passthru
    render_404
  end

  protected

  def manage_oauth_callback

    oauth_data = request.env['omniauth.auth']
    provider = Authentication.oauth_provider oauth_data
    uid = Authentication.oauth_uid oauth_data
    raw_info = Authentication.oauth_raw_info oauth_data
    user_info = Authentication.oauth_user_info oauth_data

    if user_info[:email] && !user_info[:email_verified]
      flash[:error] = I18n.t('devise.omniauth_callbacks.account_not_verified', provider: provider.capitalize)
      return redirect_to new_user_registration_path
    end

    # se sono già autenticato allora sto facendo una join dei due account
    if current_user
      auth = Authentication.find_by_provider_and_uid(provider, uid)
      # se c'è già un altro utente con associato l'account del provider
      if auth

        if provider == Authentication::FACEBOOK
          #se devo aggiornare il token...fallo
          new_token = oauth_data['credentials']['token']
          auth.update(token: new_token) if auth.token != new_token

          return redirect_to request.env['omniauth.origin'] + '?share=true' if request.env['omniauth.params']['share']
        end

        #annulla l'operazione!
        flash[:error] = I18n.t('devise.omniauth_callbacks.join_failure', provider: provider.capitalize)
      else
        current_user.oauth_join(oauth_data)
        flash[:notice] = I18n.t('devise.omniauth_callbacks.join_success', provider: provider.capitalize)
      end
      redirect_to privacy_preferences_users_url
    else

      @user, first_association, found_from_email = User.find_or_create_for_oauth_provider(oauth_data)
      if @user
        if found_from_email && !user_info[:email].nil?
          session['devise.omniauth_data'] = env['omniauth.auth']
          redirect_to confirm_credentials_users_url
        else
          flash[:notice] = first_association ? I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize) : I18n.t('devise.sessions.user.signed_in')
          @user.remember_me = true
          sign_in_and_redirect @user, event: :authentication
        end
      else
        flash[:error] = I18n.t('devise.omniauth_callbacks.creation_failure', provider: provider.capitalize)
        redirect_to new_user_registration_path
      end
    end
  end

end
