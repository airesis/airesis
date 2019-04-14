class TagsController < ApplicationController
  layout 'open_space'

  # l'utente deve aver fatto login
  before_action :authenticate_user!, except: [:index, :show]

  def show
    @kt = Tag.find_by(text: params[:id])
    if @kt
      @page_title = I18n.t('pages.tags.show.title', tag: params[:id])
      @tag = params[:id]
      @blog_posts_ids = BlogPost.published.joins(:tags).where(tags: { text: @tag }).pluck('blog_posts.id')
      @blog_posts = BlogPost.where(id: @blog_posts_ids).includes(:blog, :tags, :user).order('created_at desc')
      @proposals = Proposal.visible.joins(:tags).for_list(current_user.try(:id)).where(tags: { text: @tag })
      @groups = Group.joins(:tags).where(tags: { text: @tag })

      @similars = Tag.find_by_text(@tag).nearest

      respond_to do |format|
        format.html
      end
    else
      @page_title = I18n.t('pages.tags.show.not_found', tag: params[:id])

      @tags = Tag.most_used(current_domain.territory)

      respond_to do |format|
        format.html { render 'index' }
      end
    end
  end

  def index
    if params[:q]
      hint = params[:q] + '%'
      @tags = Tag.includes(:tag_counters).references(:tag_counters).where('upper(text) like upper(?)', hint.strip).
        order('(groups_count + blog_posts_count + proposals_count) desc').
        limit(10).collect { |t| { id: t.id.to_s, name: t.text } }

      respond_to do |format|
        format.json { render json: @tags }
      end
    else
      @page_title = I18n.t('pages.tags.index.title')
      @tags = Tag.most_used(current_domain.territory)
      respond_to do |format|
        format.html
      end
    end
  end
end
