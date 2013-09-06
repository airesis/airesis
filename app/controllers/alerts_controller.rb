#encoding: utf-8
class AlertsController < ApplicationController
  before_filter :authenticate_user!


  layout 'open_space'

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
      @map << {:id => category.id, :short => category.short.downcase, :count => numunread, :title => category.description.upcase, :alerts => unread.map { |alert| {:id => alert.id, :path => alert.checked ? alert.notification.url : check_alert_alert_path(alert), :created_at => (l alert.created_at), :checked => alert.checked, :text => alert.notification.message} }}
    end
  end

  #imposta tutte fle notifiche come lette
  def read_alerts
    @new_user_alerts = current_user.user_alerts.update_all("checked = true", "checked = false")
  end

  #marca come 'letta' una notifica e redirige verso l'url indicato
  def check_alert
    begin
      @user_alert = current_user.admin? ? UserAlert.find(params[:id]) : current_user.user_alerts.find_by_id(params[:id])
      @user_alert.checked = true
      @user_alert.save

      respond_to do |format|
        format.js { render :nothing => true }
        format.html { redirect_to @user_alert.notification.url }
      end


    rescue Exception => e
      @title = 'Impossibile recuperare la notifica'
      @message = "Probabilmente hai più di un account su Airesis e non sei autenticato con quello a cui è destinata la notifica<br/>Esci ed entra con l'account corretto."
      render template: "/errors/404", status: 404, layout: true
    end

  end

  #check all notifications in a specific category
  def check_all
    current_user.user_alerts.joins(:notification => :notification_type).where(['notification_category_id = ?', params[:id].to_i]).update_all(:checked => true)
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  protected

end