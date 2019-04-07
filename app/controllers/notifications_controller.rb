class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def change_notification_block
    respond_to_block change_block(current_user.blocked_alerts)
  end

  def change_email_notification_block
    respond_to_block change_block(current_user.blocked_emails)
  end

  def change_email_block
    respond_to_block current_user.update(receive_newsletter: !(params[:block] == 'true'))
  end

  protected

  def change_block(alerts)
    if params[:block] == 'true'
      alerts.create(notification_type_id: params[:id])
    else
      alerts.find_by(notification_type_id: params[:id]).destroy
    end
  end

  def respond_to_block(result)
    if result
      flash[:notice] = t('info.setting_preferences')
    else
      respond_to do |format|
        flash[:error] = t('error.setting_preferences')
        format.js { render 'layouts/error' }
      end
    end
  end
end
