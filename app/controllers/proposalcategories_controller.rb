#encoding: utf-8
class ProposalcategoriesController < ApplicationController
 
  def index
    @proposalcategories = ProposalCategory.find(:all, :order => "id desc")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proposalcategories }
    end
  end
  
end
