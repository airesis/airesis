class SearchParticipantsController < ApplicationController

  before_filter :load_group

  def create
    @search_participant = @group.search_participants.build(params[:search_participant])
    @group_participations = @search_participant.results.page(params[:page]).per(GroupParticipation::PER_PAGE)
    flash[:notice] = t('info.groups.search_participants')
    respond_to do |format|
      format.js
      format.html
    end
  end

end
