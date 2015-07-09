class TagsController < ApplicationController

  layout "open_space"

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, except: [:index, :show]

  def show
    @kt = Tag.find_by_text(params[:id])
    if @kt
      @page_title = "Elenco elementi con tag '" + params[:id] + "'"
      @tag = params[:id]
      @blog_posts_ids = BlogPost.published.joins(:tags).where('tags.text = ?', @tag).pluck('blog_posts.id')
      @blog_posts = BlogPost.where(id: @blog_posts_ids).includes(:blog, :tags, :user).order('created_at desc')
      @proposals = Proposal.joins(:tags).includes(:category, :quorum, :users, :vote_period, :proposal_type).where('tags.text = ?', @tag)
      @groups = Group.joins(:tags).where('tags.text = ?', @tag)

      @similars = Tag.find_by_text(@tag).nearest

      respond_to do |format|
        format.html
      end
    else
      @page_title = "Tag '" + params[:id] + "' non trovato"

      @tags = Tag.most_used(current_domain.territory)

      respond_to do |format|
        format.html { render 'index' }
      end
    end
  end

  def index
    if params[:q]
      hint = params[:q] + "%"
      @tags = Tag.where(["upper(text) like upper(?)", hint.strip]).
        order("(blogs_count + blog_posts_count + proposals_count) desc").
        limit(10).collect { |t| {id: t.id.to_s, name: t.text} }

      respond_to do |format|
        format.json { render json: @tags }
      end
    else
      @page_title = 'Elenco dei tag più utilizzati'
      @tags = Tag.most_used(current_domain.territory)
      respond_to do |format|
        format.html
      end
    end

  end

end
