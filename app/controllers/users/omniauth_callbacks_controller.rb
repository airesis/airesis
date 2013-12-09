#encoding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    #se sono già autenticato allora sto facendo una join dei due account
    access_token = request.env['omniauth.auth']
    if current_user
      data = access_token['extra']['raw_info'] #dati di facebook
      auth = Authentication.find_by_provider_and_uid(access_token['provider'],access_token['uid'])
      if auth #se c'è già un altro account
        if auth.token != access_token['credentials']['token'] #se devo aggiornare il token...fallo
          auth.update_attribute(:token, access_token['credentials']['token'])
        end

        if request.env['omniauth.params']['share']
          redirect_to request.env['omniauth.origin'] + '?share=true'
        else
          #annulla l'operazione!
          flash[:error] = "Esiste già un altro account associato a questo account Facebook. Attendi la funzione di 'Unione account' per procedere"
          redirect_to privacy_preferences_users_url
        end

      else
        if data['verified']
          current_user.build_authentication_provider(access_token)
          unless current_user.email
            current_user.email = data['email']
          end
          current_user.facebook_page_url = data['link']
          current_user.save(:validate => false)
          flash[:notice] = 'Unione account avvenuta corretamente. Complimenti, ora puoi fare login anche attraverso Facebook.'
        else
          flash[:error] = "Account facebook non verificato."
        end
        redirect_to privacy_preferences_users_url
      end


    else
      @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
      if @user
        #se all'utente è già collegato un account facebook
        if @user.has_provider(Authentication::FACEBOOK)
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
          @user.remember_me = true
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
  end
  
  def google_oauth2
    #se sono già autenticato allora sto facendo una join dei due account
    access_token = request.env['omniauth.auth']
    logger.info access_token
    if current_user   #sto agganciando il provider
      data = access_token['extra']['raw_info'] #dati di google
      auth = Authentication.find_by_provider_and_uid(access_token['provider'],access_token['uid'])
      if auth #se c'è già un altro account annulla l'operazione!
        flash[:error] = "Esiste già un altro account associato a questo account Google. Attendi la funzione di 'Unione account' per procedere"
      else
        current_user.build_authentication_provider(access_token)
        unless current_user.email
          current_user.email = data['email']
        end
        current_user.google_page_url = data['link']
        current_user.save(:validate => false)
        flash[:notice] = 'Unione account avvenuta corretamente. Complimenti, ora puoi fare login anche attraverso Google.'
      end
      redirect_to privacy_preferences_users_url
    else
      @user = User.find_for_google_oauth2(access_token, current_user)
      if @user
        #se all'utente è già collegato un account google
        if @user.has_provider(Authentication::GOOGLE)
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
          @user.remember_me = true
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
  end


  def twitter
    #se sono già autenticato allora sto facendo una join dei due account
    access_token = request.env['omniauth.auth']
    if current_user
      data = access_token['extra']['raw_info'] #dati di twitter
      auth = Authentication.find_by_provider_and_uid(access_token['provider'],access_token['uid'])
      if auth #se c'è già un altro account annulla l'operazione!
        flash[:error] = "Esiste già un altro account associato a questo account Twitter. Attendi la funzione di 'Unione account' per procedere"
      else
        current_user.build_authentication_provider(access_token)
        current_user.save(:validate => false)
        flash[:notice] = 'Unione account avvenuta corretamente. Complimenti, ora puoi fare login anche attraverso Twitter.'
      end
      redirect_to privacy_preferences_users_url
    else
      @user = User.find_for_twitter(request.env["omniauth.auth"], current_user)
      if @user
        #se all'utente è già collegato un account twitter
        if @user.has_provider(Authentication::TWITTER)
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
          #cheidigli di inserire l'email se è il primo accesso
          if @user.sign_in_count == 0
            request.env["omniauth.origin"] = nil
            session["user_return_to"] = user_path(@user, {:insert_email => true})
          end
          @user.remember_me = true
          sign_in_and_redirect @user, :event => :authentication
        elsif @user.from_identity_provider?
          flash[:error] = "Esiste già un altro account registrato a tuo nome."
          redirect_to new_user_session_path
        else
          session["devise.twitter_data"] = request.env["omniauth.auth"]
          redirect_to confirm_credentials_users_url
        end
      else
        flash[:error] = "Account Twitter non verificato."
        redirect_to proposals_path
      end
    end
  end

  def meetup
    #se sono già autenticato allora sto facendo una join dei due account
    access_token = request.env['omniauth.auth']
    if current_user
      data = access_token['extra']['raw_info'] #dati di meetup
      auth = Authentication.find_by_provider_and_uid(access_token['provider'],access_token['uid'].to_s)
      if auth #se c'è già un altro account annulla l'operazione!
        flash[:error] = "Esiste già un altro account associato a questo account Meetup. Attendi la funzione di 'Unione account' per procedere"
      else
        current_user.build_authentication_provider(access_token)
        current_user.save(:validate => false)
        flash[:notice] = 'Unione account avvenuta corretamente. Complimenti, ora puoi fare login anche attraverso Meetup.'
      end
      redirect_to privacy_preferences_users_url
    else
      @user = User.find_for_meetup(request.env["omniauth.auth"], current_user)
      if @user
        #se all'utente è già collegato un account meetup
        if @user.has_provider(Authentication::MEETUP)
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Meetup"
          #cheidigli di inserire l'email se è il primo accesso
          if @user.sign_in_count == 0
            request.env["omniauth.origin"] = nil
            session["user_return_to"] = user_path(@user, {:insert_email => true})
          end
          @user.remember_me = true
          sign_in_and_redirect @user, :event => :authentication
        elsif @user.from_identity_provider?
          flash[:error] = "Esiste già un altro account registrato a tuo nome."
          redirect_to new_user_session_path
        else
          session["devise.meetup_data"] = request.env["omniauth.auth"]
          redirect_to confirm_credentials_users_url
        end
      else
        flash[:error] = "Account Meetup non verificato."
        redirect_to proposals_path
      end
    end
  end



  def parma
    #se sono già autenticato allora sto facendo una join dei due account
    access_token = request.env['omniauth.auth']
    if current_user
      data = access_token['info'] #dati di meetup
      auth = Authentication.find_by_provider_and_uid(access_token['provider'],access_token['uid'].to_s)
      if auth #se c'è già un altro account annulla l'operazione!
        flash[:error] = "Esiste già un altro account associato a questo account Parma. Attendi la funzione di 'Unione account' per procedere"
      else
        current_user.build_authentication_provider(access_token)
        current_user.save(:validate => false)
        flash[:notice] = 'Unione account avvenuta corretamente. Complimenti, ora puoi fare login anche attraverso Parma.'
      end
      redirect_to privacy_preferences_users_url
    else
      @user = User.find_for_parma(access_token, current_user)
      if @user
        #se all'utente è già collegato un account parma
        if @user.has_provider(Authentication::PARMA)
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Parma"
          @user.remember_me = true
          sign_in @user, :event => :authentication
          redirect_to group_url(Group.find_by_subdomain('parma'))
        elsif @user.from_identity_provider?
          flash[:error] = "Esiste già un altro account registrato a tuo nome."
          redirect_to group_url(Group.find_by_subdomain('parma'))
        else
          session["devise.parma_data"] = request.env["omniauth.auth"]
          redirect_to confirm_credentials_users_url
        end
      else
        flash[:error] = "Account Parma non verificato."
        redirect_to group_url(Group.find_by_subdomain('parma'))
      end
    end
  end


  def linkedin
    #se sono già autenticato allora sto facendo una join dei due account
    access_token = request.env['omniauth.auth']
    if current_user
      data = access_token['extra']['raw_info'] #dati di linkedin
      auth = Authentication.find_by_provider_and_uid(access_token['provider'],access_token['uid'])
      if auth #se c'è già un altro account annulla l'operazione!
        flash[:error] = "Esiste già un altro account associato a questo account Linkedin. Attendi la funzione di 'Unione account' per procedere"
      else
        current_user.build_authentication_provider(access_token)
        unless current_user.email
          current_user.email = data['email']
        end
        current_user.linkedin_page_url = data[:publicProfileUrl]
        current_user.save(:validate => false)
        flash[:notice] = 'Unione account avvenuta corretamente. Complimenti, ora puoi fare login anche attraverso Linkedin.'
      end
      redirect_to privacy_preferences_users_url
    else
      @user = User.find_for_linkedin_oauth(env["omniauth.auth"], current_user)
      if @user
        #se all'utente è già collegato un account linkedin
        if @user.has_provider(Authentication::LINKEDIN)
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Linkedin"
          @user.remember_me = true
          sign_in_and_redirect @user, :event => :authentication
        elsif @user.from_identity_provider?
          flash[:error] = "Esiste già un altro account con questo indirizzo email."
          redirect_to new_user_session_path
        else
          session["devise.linkedin_data"] = request.env["omniauth.auth"]
          redirect_to confirm_credentials_users_url
        end
      else
        flash[:error] = "Account Linkedin non verificato."
        redirect_to proposals_path
      end
    end
  end

  def passthru
    render_404
  end
end
