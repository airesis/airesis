#encoding: utf-8
class AreaParticipationsController < ApplicationController

  layout 'groups'

  before_filter :load_group

  before_filter :authenticate_user!

  authorize_resource :group
  load_and_authorize_resource :group_area, through: :group

  before_filter :load_area_participation, only: :destroy

  load_and_authorize_resource through: :group_area



  def create
      #part = @group_area.area_participations.new
      #part.user_id = params[:user_id]
    #todo check if the user can be added to the area
    @area_participation.area_role_id = @group_area.area_role_id
      if @area_participation.save
        flash[:notice] = t('info.area_participation.create')
      else
        flash[:error] = t('error.area_participation.create')
      end
  end

  def destroy
    @area_participation.destroy
    flash[:notice] = t('info.area_participation.destroy')
  end

  protected

  def load_area_participation
    @area_participation = @group_area.area_participations.find_by(user_id: area_participation_params[:user_id])
  end

  def area_participation_params
    params.require(:area_participation).permit(:user_id)
  end

end
