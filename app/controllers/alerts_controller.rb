#encoding: utf-8
class AlertsController < ApplicationController
  before_filter :authenticate_user!

  layout 'users'

  load_and_authorize_resource except: [:check_all,:proposal], through: :current_user

  def index
    respond_to do |format|
      format.html {
        @page_title = "All alerts"
        @new_alerts = @alerts.includes(:notification).where(checked: false)
        @old_alerts = @alerts.includes(:notification).where(checked: true)
      }
      format.json {
        unread = @alerts.where({checked: false, deleted: false}).includes(:notification_type, :notification_category)
        numunread = unread.count
        if numunread < 10
          unread += @alerts.where({checked: true, deleted: false}).includes(:notification_type, :notification_category).limit(10 - numunread)
        end

        alerts = unread.map do |alert|
          puts "user? #{ alert.nproperties['user_id']}"
          {id: alert.id,
           path: alert.checked ? alert.notification.url : check_alert_url(alert),
           created_at: (time_in_words alert.created_at),
           checked: alert.checked,
           text: alert.message,
           proposal_id: alert.data[:proposal_id],
           category_name: alert.notification_category.short.downcase,
           category_title: alert.notification_category.description.upcase,
           image: alert.nproperties['user_id'].present? ? User.find(alert.nproperties['user_id']).user_image_url : ActionController::Base.helpers.asset_path("notification_categories/#{alert.notification_category.short.downcase}.png")}
        end
        @map = {count: numunread, alerts: alerts}
        render json: @map
      }
    end
  end

  #sign as read an alert and redirect to corresponding url
  def check
    begin
      @alert = current_user.admin? ? Alert.find(params[:id]) : current_user.alerts.find_by_id(params[:id])
      @alert.check!

      respond_to do |format|
        format.js { render nothing: true }
        format.html { redirect_to @alert.notification.url }
      end


    rescue Exception => e
      @title = 'Impossibile recuperare la notifica' #TODO:I18n
      @message = "Probabilmente hai più di un account su Airesis e non sei autenticato con quello a cui è destinata la notifica<br/>Esci ed entra con l'account corretto."
      render template: "/errors/404", status: 404, layout: true
    end

  end

  #todo to remove in one year from 08-05-2014
  def check_alert
    check
  end

  #check all notifications
  def check_all
    current_user.unread_alerts.check_all
    respond_to do |format|
      format.js { render nothing: true }
    end
  end

  #return notification tooltip for a specific proposal and user
  def proposal
    @proposal_id = params[:proposal_id]
    @unread = current_user.alerts.where(["(notifications.properties -> 'proposal_id') = ? and alerts.checked = ?", @proposal_id.to_s, false])
    render layout: false
  end
end
