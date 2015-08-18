class NotificationsController < ApplicationController

  before_filter :authenticate_user!

  #cambia l'impostazione delle notifiche che si vogliono ricevere
  def change_notification_block
    if params[:block] == 'true'
      b = current_user.blocked_alerts.build(notification_type_id: params[:id])
      b.save!
    else
      b = current_user.blocked_alerts.find_by(notification_type_id: params[:id])
      b.destroy
    end
    flash[:notice] =t('info.setting_preferences')

  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
    end
  end

  #cambia l'impostazione delle notifiche che si vogliono ricevere via email
  def change_email_notification_block
    if params[:block] == 'true'
      b = current_user.blocked_emails.build(notification_type_id: params[:id])
      b.save!
    else
      b = current_user.blocked_emails.find_by(notification_type_id: params[:id])
      b.destroy
    end
    flash[:notice] = t('info.setting_preferences')

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
    end
  end

  #cambia la ricezione delle newsletter
  def change_email_block
    if params[:block] == 'true'
      current_user.receive_newsletter = false
      current_user.save!
    else
      current_user.receive_newsletter = true
      current_user.save!
    end
    flash[:notice] = t('info.setting_preferences')

  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
    end
  end
end
