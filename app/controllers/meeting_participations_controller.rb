class MeetingParticipationsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :event
  load_and_authorize_resource through: :event

  def create
    @meeting_participation.user = current_user
    if @meeting_participation.save
      flash[:notice] = 'La tua risposta è stata inviata.'
      respond_to do |format|
        format.html do
          redirect_to event_path(params[:event_id])
        end
        format.js
      end
    else
      flash[:error] = t('error.event_answer')
      respond_to do |format|
        format.html do
          redirect_to event_path(params[:event_id])
        end
      end
    end
  end

  protected

  def meeting_participation_params
    params.require(:meeting_participation).permit(:comment, :guests, :response)
  end
end
