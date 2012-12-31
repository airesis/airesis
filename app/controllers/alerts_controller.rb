#encoding: utf-8
class AlertsController < ApplicationController

  before_filter :authenticate_user!
  
  #mostra gli alert dell'utente corrente
  def index
    @page_title = "Tutte le notifiche"
    @new_user_alerts = current_user.user_alerts.all(:include => :notification, :conditions => 'checked = false')
    @old_user_alerts = current_user.user_alerts.all(:include => :notification, :conditions => 'checked = true')
  end
  
  def polling
    @new_user_alerts = current_user.user_alerts.all(:include => :notification, :conditions => 'checked = false')
    if (@new_user_alerts.size < 5)
        @old_user_alerts = current_user.user_alerts.all(:include => :notification, :conditions => 'checked = true', :limit => (5 - @new_user_alerts.size))
    end
  end
  
  #restituisce le nuove notifiche per l'utente
  def read_alerts
    @new_user_alerts = current_user.user_alerts.update_all("checked = true", "checked = false")
  end
  
  #marca come 'letta' una notifica e redirige verso l'url indicato
  def check_alert
    @user_alert = UserAlert.find_by_id(params[:id])
    @user_alert.checked = true
    @user_alert.save
    redirect_to @user_alert.notification.url
  end
  
  protected
  
end