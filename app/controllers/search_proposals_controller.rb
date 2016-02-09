class SearchProposalsController < ApplicationController
  def create
    @proposals = SearchProposal.new(params[:search_proposal]).results
    flash[:notice] = t('info.groups.search_proposal')
    respond_to do |format|
      format.html
      format.js
    end
  end
end
