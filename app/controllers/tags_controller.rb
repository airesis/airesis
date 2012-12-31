#encoding: utf-8
class TagsController < ApplicationController
  
  layout "settings"

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:show]
  
  def show
    @page_title = "Elenco elementi con tag '" + params[:text] + "'"
    @tag = params[:text]
    @blog_posts = BlogPost.published.all(:joins => :tags , :conditions => {'tags.text' => @tag})
    @proposals = Proposal.all(:joins => :tags , :conditions => {'tags.text' => @tag})
    
    respond_to do |format|
      format.html
      #format.xml  { render :xml => @blog_posts }
    end   
  end
     
end
