#encoding: utf-8
class TagsController < ApplicationController
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:show]
  
  def show
    @tag = params[:text]
    @blog_posts = BlogPost.published.find(:all, :joins => :tags , :conditions => {'tags.text' => @tag})
    @proposals = Proposal.find(:all, :joins => :tags , :conditions => {'tags.text' => @tag})
    
    respond_to do |format|
      format.html
      #format.xml  { render :xml => @blog_posts }
    end   
  end
     
end
