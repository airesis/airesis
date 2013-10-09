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
    @map = []

    current_user.user_alerts.includes({:notification => [:notification_data,{:notification_type => :notification_category}]}).where(['user_alerts.checked = false']).group_by{|a| a.notification.notification_type.notification_category}.each do |category,alerts|
      numunread = alerts.size
      if numunread < 10
        alerts += current_user.user_alerts.all(:joins => {:notification => {:notification_type => :notification_category}}, :include => {:notification => :notification_data}, :conditions => ['user_alerts.checked = true and notification_categories.id = ?', category.id], :limit => (10 - numunread))
      end
      @map << {:id => category.id, :short => category.short.downcase, :count => numunread, :title => category.description.upcase, :alerts => alerts.map { |alert| {:id => alert.id, :path => alert.checked ? alert.notification.url : check_alert_alert_url(alert), :created_at => (l alert.created_at), :checked => alert.checked, :text => alert.notification.message, :proposal_id => alert.notification.data[:proposal_id]} }}
    end

#    NotificationCategory.all.each do |category|
#      logger.info "category #{category.description}"
#      unread = current_user.user_alerts.all(:joins => {:notification => {:notification_type => :notification_category}}, :include => {:notification => :notification_data}, :conditions => ['user_alerts.checked = false and notification_categories.id = ?', category.id])
#      numunread = unread.size
#      if numunread < 10
#        unread += current_user.user_alerts.all(:joins => {:notification => {:notification_type => :notification_category}}, :include => {:notification => :notification_data}, :conditions => ['user_alerts.checked = true and notification_categories.id = ?', category.id], :limit => (10 - numunread))
#      end
#      @map << {:id => category.id, :short => category.short.downcase, :count => numunread, :title => category.description.upcase, :alerts => unread.map { |alert| {:id => alert.id, :path => alert.checked ? alert.notification.url : check_alert_alert_url(alert), :created_at => (l alert.created_at), :checked => alert.checked, :text => alert.notification.message, :proposal_id => alert.notification.data[:proposal_id]} }}
#    end
  end

  #imposta tutte fle notifiche come lette
  def read_alerts
    @new_user_alerts = current_user.unread_alerts.check_all
  end

  #marca come 'letta' una notifica e redirige verso l'url indicato
  def check_alert
    begin
      @user_alert = current_user.admin? ? UserAlert.find(params[:id]) : current_user.user_alerts.find_by_id(params[:id])
      @user_alert.check!

      respond_to do |format|
        format.js { render :nothing => true }
        format.html { redirect_to @user_alert.notification.url }
      end


    rescue Exception => e
      @title = 'Impossibile recuperare la notifica' #TODO:I18n
      @message = "Probabilmente hai più di un account su Airesis e non sei autenticato con quello a cui è destinata la notifica<br/>Esci ed entra con l'account corretto."
      render template: "/errors/404", status: 404, layout: true
    end

  end

  #check all notifications in a specific category
  def check_all
    current_user.user_alerts.joins(:notification => :notification_type).where(['notification_category_id = ? and user_alerts.checked = ?', params[:id].to_i, false]).check_all
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  #return notification tooltip for a specific proposal and user
  def proposal
    @unread = current_user.user_alerts.joins({:notification => :notification_data}).where(['notification_data.name = ? and notification_data.value = ? and user_alerts.checked = ?', 'proposal_id', params[:proposal_id], false])
    render layout: false
  end

  protected

end