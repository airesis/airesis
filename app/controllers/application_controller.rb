#encoding: utf-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  after_filter :discard_flash_if_xhr

  before_filter :store_location #salvo l'indirizzo dal quale provengo

  
  helper_method :is_admin?, :is_proprietary?, :current_url, :link_to_auth
  
  def render_404
    respond_to do |format|
      format.html { render "errors/404", :status => 404, :layout => false }
      format.xml  { render :nothing => true, :status => '404 Not Found' }
    end
    true
  end

  
  def current_url(overwrite={})
    url_for params.merge(overwrite).merge(:only_path => false)
  end
  
  #helper method per determinare se l'utente attualmente collegato è amministratore di sistema
  def is_admin? 
    if user_signed_in? && current_user.user_type.short_name == "admin"
      true
    else
      false
    end
  end
  
  #helper method per determinare se l'utente attualmente collegato è il proprietario di un determinato oggetto
  def is_proprietary? object
    if (current_user && current_user.is_mine?(object))
      return true
    else
      return false
    end      
  end
  
  def link_to_auth (text, link)
      return "<a>login</a>"
  end
  
  def title(ttl)
    @page_title = ttl
  end
  
   def check_events_permissions
    if !is_admin?
      group_id = params[:group_id] || params[:event][:organizer_id] 
      permissions_denied if !group_id
      @group = Group.find_by_id(group_id)
      permissions_denied if !@group
      ok = ((current_user == @group.portavoce) rescue nil)
      permissions_denied if !ok
    end
  end
  
  def check_event_edit_permission
    return true if is_admin?
    @event = Event.find_by_id(params[:id])
    org = @event.organizers.first
    if !org
      permissions_denied
      return
    end
    p = org.portavoce
    permissions_denied if (!current_user || current_user != p)
  end
  
  def admin_required
    is_admin? || admin_denied
  end
  
  #risposta nel caso sia necessario essere amministartori
  def admin_denied
    respond_to do |format|
      format.js do        #se era una chiamata ajax, mostra il messaggio
        flash.now[:notice] = t('error.admin_required')
        render :update do |page|
           page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end  
      end
      format.html do   #ritorna indietro oppure all'HomePage
        store_location
        flash[:notice] = t('error.admin_required')
        if request.env["HTTP_REFERER"]
          redirect_to :back
        else
          redirect_to proposals_path
        end        
      end
    end
  end
  
  #risposta generica nel caso non si abbiano i privilegi per eseguire l'operazione
  def permissions_denied
    respond_to do |format|
      format.js do        #se era una chiamata ajax, mostra il messaggio
        flash.now[:notice] = t('error.permissions_required')
        render :update do |page|
           page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end  
      end
      format.html do   #ritorna indietro oppure all'HomePage
        store_location
        flash[:notice] = t('error.permissions_required')
        if request.env["HTTP_REFERER"]
          redirect_to :back
        else
          redirect_to proposals_path
        end        
      end
    end
  end
  
  #salva l'url
  def store_location
     unless ((params[:controller].starts_with? "devise/") ||
             (params[:controller] == "users/omniauth_callbacks") || 
             (params[:controller] == "alerts" && params[:action] == "polling"))
      session[:user_return_to] = request.url
      end
      # If devise model is not User, then replace :user_return_to with :{your devise model}_return_to
  end
  
  #redirect all'ultima pagina
  def after_sign_in_path_for(resource)
     env = request.env
     ret = env['omniauth.origin'] || stored_location_for(resource) || root_path
      return ret
  end
  
  protected
  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end
  
  
  
end
