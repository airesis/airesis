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

    oauth_data_parser = OauthDataParser.new(oauth_data)
    provider = oauth_data_parser.provider
    uid = oauth_data_parser.uid
    user_info = oauth_data_parser.user_info

    if user_info[:email] && !user_info[:email_verified]
      flash[:error] = I18n.t('devise.omniauth_callbacks.account_not_verified', provider: provider.capitalize)
      return redirect_to new_user_registration_path
    end

    # se sono già autenticato allora sto facendo una join dei due account
    if current_user.present?
      auth = Authentication.find_by(provider: provider, uid: uid)
      # se c'è già un altro utente con associato l'account del provider
      if auth.present?
        if provider == Authentication::FACEBOOK
          #se devo aggiornare il token...fallo
          new_token = oauth_data['credentials']['token']
          auth.update(token: new_token) if auth.token != new_token
          return redirect_to request.env['omniauth.origin'] + '?share=true' if request.env['omniauth.params']['share']
        end
        # cancel_operation
        flash[:error] = I18n.t('devise.omniauth_callbacks.join_failure', provider: provider.capitalize)
      else
        # the certified email is already present in another account in Airesis
        # cannot update user email with one already taken
        if user_info[:certified] &&
           User.all_except(current_user).where(email: user_info[:email]).exists?
          flash[:error] = I18n.t 'devise.omniauth_callbacks.certified_email_taken'
          return redirect_to privacy_preferences_users_url
        end

        # A user cannot have more than one certified account
        if oauth_data_parser.multiple_certification_attempt?
          flash[:error] = I18n.t 'devise.omniauth_callbacks.already_certified'
          return redirect_to privacy_preferences_users_url
        end

        current_user.oauth_join(oauth_data)
        flash[:notice] = I18n.t('devise.omniauth_callbacks.join_success', provider: provider.capitalize)
      end
      redirect_to privacy_preferences_users_url
    else
      @user, first_association, found_from_email = User.find_or_create_for_oauth_provider(oauth_data)
      if @user.present?
        if found_from_email && user_info[:email].present?
          session['devise.omniauth_data'] = env['omniauth.auth']
          redirect_to confirm_credentials_users_url
        else
          flash[:notice] = first_association ? I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize) : I18n.t('devise.sessions.user.signed_in')
          @user.remember_me = true
          sign_in_and_redirect @user, event: :authentication
        end
      else # something went wrong while creating a new user with oauth info
        if oauth_data_parser.multiple_certification_attempt?
          flash[:error] = I18n.t 'devise.omniauth_callbacks.already_certified'
        else
          flash[:error] = I18n.t('devise.omniauth_callbacks.creation_failure', provider: provider.capitalize)
        end
        redirect_to new_user_registration_path
      end
    end
  end
end
