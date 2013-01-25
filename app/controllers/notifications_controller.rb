#encoding: utf-8
class NotificationsController < ApplicationController

  before_filter :authenticate_user!
  
  
  def change_notification_block
    if (params[:block] == "true")
      b = current_user.blocked_alerts.build(:notification_type_id => params[:id])
      b.save!
    else
      b = current_user.blocked_alerts.first(:conditions => {:notification_type_id => params[:id]})
      b.destroy
    end
    flash[:info] = t('info.setting_preferences')

  rescue ActiveRecord::ActiveRecordError => e
    puts e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js   { render :update do |page|
                     page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                    end}
    end
  end


  def change_email_notification_block
    if (params[:block] == "true")
      b = current_user.blocked_emails.build(:notification_type_id => params[:id])
      b.save!
    else
      b = current_user.blocked_emails.first(:conditions => {:notification_type_id => params[:id]})
      b.destroy
    end
    flash[:info] = t('info.setting_preferences')

  rescue ActiveRecord::ActiveRecordError => e
    puts e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js   { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end}
    end
  end

end
