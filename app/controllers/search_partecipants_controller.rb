class SearchPartecipantsController < ApplicationController

  before_filter :load_group

  def create
    @partecipants = @group.search_partecipants.build(params[:search_partecipant]).results
    flash[:notice] = t('info.groups.search_participants')
    respond_to do |format|
      format.js
      format.html
    end
  end

end
