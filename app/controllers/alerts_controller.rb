#encoding: utf-8
class AlertsController < ApplicationController
  before_filter :authenticate_user!


  layout 'users'

  #mostra gli alert dell'utente corrente
  def index
    @page_title = "Tutte le notifiche"
    @user = current_user if current_user
    @new_user_alerts = current_user.user_alerts.all(:include => :notification, :conditions => 'checked = false')
    @old_user_alerts = current_user.user_alerts.all(:include => :notification, :conditions => 'checked = true')

  end

  def polling
    unread = current_user.user_alerts.where({checked: false, deleted: false}).includes(:notification_type,:notification_category)
    numunread = unread.count
    if numunread < 10
      unread += current_user.user_alerts.where({checked: true, deleted: false}).includes(:notification_type,:notification_category).limit(10 - numunread)
    end
    alerts = unread.map do |alert|
      {id: alert.id,
       path: alert.checked ? alert.notification.url : check_alert_alert_url(alert),
       created_at: (time_in_words alert.created_at),
       checked: alert.checked,
       text: alert.message,
       proposal_id: alert.data[:proposal_id],
       category_name: alert.notification_category.short.downcase,
       category_title: alert.notification_category.description.upcase,
       image: "<img src=\"/assets/notification_categories/#{alert.notification_category.short.downcase}.png\"/>"}
    end
    @map = {:count => numunread, :alerts => alerts}
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
    current_user.user_alerts.where(['user_alerts.checked = ?', false]).check_all
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  #return notification tooltip for a specific proposal and user
  def proposal
    @unread = current_user.user_alerts.where(["(notifications.properties -> 'proposal_id') = ? and user_alerts.checked = ?", params[:proposal_id].to_s, false])
    render layout: false
  end

  protected

end