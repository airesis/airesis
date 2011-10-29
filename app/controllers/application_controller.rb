#encoding: utf-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  after_filter :discard_flash_if_xhr

  
  helper_method :is_admin?, :is_proprietary?, :current_url, :link_to_auth
  
  def current_url(overwrite={})
    url_for params.merge(overwrite).merge(:only_path => false)
  end
  
  #helper method per determinare se l'utente attualmente collegato è amministratore di sistema
  def is_admin? 
    if logged_in? && current_user.user_type.short_name == "admin"
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
  
  
  def admin_required
    is_admin? || admin_denied
  end
  
  def admin_denied
    respond_to do |format|
      format.html do
        store_location
        flash[:notice] = t(:error_admin_required)
        if request.env["HTTP_REFERER"]
          redirect_to :back
        else
          redirect_to proposals_path
        end        
      end
    end
  end
  
#  def access_denied
#    respond_to do |format|
#      format.html do
#        store_location
#        flash[:notice] = t(:error_not_logged_in)
#        if request.env["HTTP_REFERER"]
#          redirect_to :back
#        else
#          redirect_to proposals_path
#        end
#      end
#    end
#  end
  
  protected
  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end
  
  
  
end
