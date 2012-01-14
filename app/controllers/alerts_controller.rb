#encoding: utf-8
class AlertsController < ApplicationController

  before_filter :authenticate_user!

  #mostra gli alert dell'utente corrente
  def index
    @new_user_alerts = current_user.user_alerts.find(:all, :include => :notification, :conditions => 'checked = false')
    @old_user_alerts = current_user.user_alerts.find(:all, :include => :notification, :conditions => 'checked = true')
  end
  
end  