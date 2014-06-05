#encoding: utf-8
class MeetingParticipationsController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource :event
  load_and_authorize_resource through: :event

  def create
    @meeting_participation.user = current_user
    if @meeting_participation.save
      flash[:notice] = "La tua risposta è stata inviata."
      respond_to do |format|
        format.js
        format.html {
          redirect_to event_path(params[:event_id])
        }
      end
    else
      flash[:error] = t('error.event_answer')
      respond_to do |format|
        format.html {
          redirect_to event_path(params[:event_id])
        }
      end
    end
  end
end