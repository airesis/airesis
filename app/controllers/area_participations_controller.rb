#encoding: utf-8
class AreaParticipationsController < ApplicationController
  include NotificationHelper

  layout 'groups'

  before_filter :load_group

  before_filter :authenticate_user!

  authorize_resource :group
  load_and_authorize_resource :group_area, through: :group
  load_and_authorize_resource through: :group_area

  def create
      part = group_area.area_participations.new
      part.user_id = params[:user_id]
      part.area_role_id = group_area.area_role_id
      part.save!
  end

  def destroy
    group_area.area_participations.where(user_id: params[:user_id]).destroy_all
  end
end
