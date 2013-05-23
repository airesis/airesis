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
    if @new_user_alerts.size < 5
        @old_user_alerts = current_user.user_alerts.all(:include => :notification, :conditions => 'checked = true', :limit => (5 - @new_user_alerts.size))
    end

    @map = []
    NotificationCategory.all.each do |category|
      unread = current_user.user_alerts.all(:joins => {:notification => {:notification_type => :notification_category}}, :include => :notification, :conditions => ['user_alerts.checked = false and notification_categories.id = ?', category.id])
      numunread = unread.size
      if numunread < 10
        unread += current_user.user_alerts.all(:joins => {:notification => {:notification_type => :notification_category}}, :include => :notification, :conditions => ['user_alerts.checked = true and notification_categories.id = ?', category.id], :limit => (10 - numunread))
      end
      @map << {:id => category.id,:short => category.short.downcase!, :count => numunread, :title => category.description.upcase!, :alerts => unread.map{|alert| {:id => alert.id, :path => alert.checked ? alert.notification.url : check_alert_alert_path(alert), :created_at => (l alert.created_at), :checked => alert.checked, :text => alert.notification.message}}}
    end
  end
  
  #imposta tutte fle notifiche come lette
  def read_alerts
    @new_user_alerts = current_user.user_alerts.update_all("checked = true", "checked = false")
  end
  
  #marca come 'letta' una notifica e redirige verso l'url indicato
  def check_alert
    @user_alert = UserAlert.find_by_id(params[:id])
    @user_alert.checked = true
    @user_alert.save

    respond_to do |format|
      format.js  {render :nothing => true}
      format.html {redirect_to @user_alert.notification.url}
    end
  end
  
  protected
  
end