#encoding: utf-8
class ProposalCategoriesController < ApplicationController
 
  def index
    @proposalcategories = ProposalCategory.all(:order => "id desc")
    
    respond_to do |format|
      #format.html # index.html.erb
      format.json { render :json => @proposalcategories, only: [:id, :description] }
      #format.xml  { render :xml => @proposalcategories }
    end
  end
  
end
