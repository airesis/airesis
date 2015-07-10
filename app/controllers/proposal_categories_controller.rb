class ProposalCategoriesController < ApplicationController

  def index
    @proposalcategories = ProposalCategory.all(order: "id desc")

    respond_to do |format|
      format.json { render json: @proposalcategories, only: [:id, :description] }
    end
  end

end
