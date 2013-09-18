#encoding: utf-8
class TagsController < ApplicationController

  layout "open_space"

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index, :show]

  def show
    @page_title = "Elenco elementi con tag '" + params[:id] + "'"
    @tag = params[:id]
    @blog_posts_ids = BlogPost.published.joins(:tags).where({'tags.text' => @tag}).pluck('blog_posts.id')
    @blog_posts = BlogPost.where(:id => @blog_posts_ids).includes(:blog, :tags, :user).order('created_at desc')
    @proposals = Proposal.all(:joins => :tags, :conditions => {'tags.text' => @tag}, include: [:category, :quorum, :users, :vote_period, :proposal_type])
    @groups = Group.all(:joins => :tags, :conditions => {'tags.text' => @tag})

    @similars = Tag.find_by_text(@tag).nearest

    respond_to do |format|
      format.html
      #format.xml  { render :xml => @blog_posts }
    end
  end

  def index
    hint = params[:q] + "%"
    @tags = Tag
    .all(:conditions => ["upper(text) like upper(?)", hint.strip], order: "(blogs_count + blog_posts_count + proposals_count) desc", limit: 10)
    .collect { |t| {:id => t.id.to_s, :name => t.text} }

    respond_to do |format|
      #format.xml  { render :xml => map[0,10] }
      format.json { render :json => @tags }

      #format.html # index.html.erb
    end
  end

end
