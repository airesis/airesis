#encoding: utf-8
class BlogPostsController < ApplicationController
  include NotificationHelper, GroupsHelper

  helper :blog

  layout :choose_layout

  before_filter :load_group
  before_filter :load_blog

  before_filter :authorize_parent

  def authorize_parent
    authorize! :read, @group if @group
    authorize! :read, @blog if @blog
  end

  load_and_authorize_resource through: [:blog, :group], shallow: true, collection: [:drafts]

  before_filter :load_blog_data, only: [:index, :show, :drafts]

  before_filter :check_page_alerts, only: :show

  def index
    if @blog || @group
      redirect_to (@blog || @group)
    else
      @blog_posts = @blog_posts.order(published_at: :desc).page(params[:page]).per(COMMENTS_PER_PAGE)
      @page_title = t('pages.blog_posts.index.title')
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def drafts
    @page_title = t('pages.blog_posts.drafts.title', blog: @blog.title)
    @user = @blog.user
    @blog_posts = @blog_posts.drafts.order(updated_at: :desc).page(params[:page]).per(COMMENTS_PER_PAGE)

    respond_to do |format|
      format.html
    end
  end

  def show
    @page_title = @blog_post.title
    @page_title += " [#{t('pages.blog_posts.show.draft')}]" if @blog_post.draft?
    @page_title += " [#{t('pages.blog_posts.show.reserved')}]" if @blog_post.reserved?
    @blog_url = @group ? group_blog_post_url(@group, @blog_post) : blog_blog_post_url(@blog, @blog_post)
    @user = @blog_post.user
    @blog_comment = @blog_post.blog_comments.new
    @blog_comments = @blog_post.blog_comments.includes(user: [:user_type, :image]).order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @blog_post.status = 'P'
  end

  def edit
    @user = @blog.user
  end

  def create
    @blog = current_user.blog
    @blog_post = @blog.blog_posts.build(blog_post_params)
    @blog_post.user_id = current_user.id
    respond_to do |format|
      if @blog_post.save
        flash[:notice] = t('info.blog_created')
        format.html {
          redirect_to @group ? group_url(@group) : @blog
        }
      else
        @user = @blog.user
        format.html { render action: :new }
      end
    end
  end

  def update
    @blog_post = @blog.blog_posts.find(params[:id])
    if @blog_post.update_attributes(blog_post_params)
      flash[:notice] = t('info.blog_post_updated')
      redirect_to [@blog, @blog_post]
    else
      render action: :edit
    end
  end

  def destroy
    @blog_post = @blog.blog_posts.find(params[:id])
    @blog_post.destroy
    flash[:notice] = t('info.blog_post_deleted')
    redirect_to @blog
  end

  private

  def load_blog
    @blog = Blog.friendly.find(params[:blog_id]) if params[:blog_id]
  end

  def choose_layout
    @group ? 'groups' : @blog ? 'users' : 'open_space'
  end

  protected

  def blog_post_params
    ret = params.require(:blog_post).permit(:title, :body, :status, :tags_list, group_ids: [])
    group_ids = ret[:group_ids]
    group_ids.select! { |id| (id != '') && (can? :post_to, Group.find(id)) } if group_ids
    ret
  end

  private

  def render_404(exception=nil)
    log_error(exception) if exception
    respond_to do |format|
      @title = t('error.error_404.blog_posts.title')
      @message = t('error.error_404.blog_posts.description')
      format.html { render "errors/404", status: 404, layout: true }
    end
    true
  end
end
