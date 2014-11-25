class SearchParticipantsController < ApplicationController

  before_filter :load_group

  authorize_resource :group
  load_and_authorize_resource through: :group

  def create
    @unscoped_group_participations = @search_participant.results
    @group_participations = @unscoped_group_participations.page(params[:page]).per(GroupParticipation::PER_PAGE)
    flash[:notice] = t('info.groups.search_participants')
    respond_to do |format|
      format.js
      format.html
    end
  end

  protected

  def search_participant_params
    params.require(:search_participant).permit(:keywords, :role_id, :status_id)
  end

end
