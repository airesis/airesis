#encoding: utf-8
class AlertsController < ApplicationController

  before_filter :authenticate_user!
  
  before_filter :load_alert, :only => [:check_alert]

  #mostra gli alert dell'utente corrente
  def index
    @new_user_alerts = current_user.user_alerts.find(:all, :include => :notification, :conditions => 'checked = false')
    @old_user_alerts = current_user.user_alerts.find(:all, :include => :notification, :conditions => 'checked = true')
  end
  
  def polling
    @new_user_alerts = current_user.user_alerts.find(:all, :include => :notification, :conditions => 'checked = false')
    if (@new_user_alerts.size < 5)
        @old_user_alerts = current_user.user_alerts.find(:all, :include => :notification, :conditions => 'checked = true', :limit => (5 - @new_user_alerts.size))
    end
  end
  
  def read_alerts
    @new_user_alerts = current_user.user_alerts.update_all("checked = true", "checked = false")
  end
  
  def check_alert
    @user_alert.update_attribute
  end
  
  
  protected
  
  def load_alert
    @user_alert = UserAlert.find_by_id(params[:id])
    @user_alert.checked = true
    @user_alert.save
    redirect_to @user_alert.notification.url
  end
end