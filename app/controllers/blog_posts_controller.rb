#encoding: utf-8
class BlogPostsController < ApplicationController
  include NotificationHelper, GroupsHelper

  helper :blog

  #l'utente deve aver creato un blog personale, oppure viene rimandato alla pagina per la creazione
  before_filter :require_blog, except: [:index, :show]

  #before_filter :require_user, except: [:index, :show, :tag]
  before_filter :load_blog

  before_filter :load_blog_post, only: :show

  before_filter :load_blog_data, only: :show

  #il blog caricato deve essere dell'utente.
  #l'azione può essere eseguita solo sul proprio blog, altrimenti viene dato errore e redirezionato alla pagina precedente.
  before_filter :must_be_my_blog, only: [:new, :edit, :update, :create, :destroy]


  before_filter :setup_image_template, only: [:new, :edit, :create, :update]

  before_filter :check_page_alerts, only: :show

  layout :choose_layout


  load_and_authorize_resource :blog
  load_and_authorize_resource :group

  load_and_authorize_resource through: [:blog, :group], shallow: true


  def index
    @blog_posts = @blog.posts.published.order('published_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE) if @blog
    @group_posts = @group.posts.published.order('published_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE) if @group

    @index_title = t('pages.blog_posts.index.title')

    respond_to do |format|
      format.html
      format.atom
    end
  end


  def drafts
    @page_title = t('pages.blog_posts.drafts.title', blog: @blog.title)
    @user = @blog.user
    @blog_posts = @blog.posts.drafts.order('updated_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)

    respond_to do |format|
      format.html
    end
  end


  def show
    authorize! :read, @blog_post
    @user = @blog_post.user
    @page_title = @blog_post.title
    @blog_comment = @blog_post.blog_comments.new
    @blog_comments = @blog_post.blog_comments.includes(user: [:user_type, :image]).order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @blog_post = @blog.posts.build
    @blog_post.status = 'P'

    load_post_groups

    if params[:group_id]
      group = Group.find(params[:group_id])
      if (@groups.include? group) || current_user.admin?
        @blog_post.groups << group
      end
    end
  end

  def edit
    @blog_post = @blog.posts.find(params[:id])
    @user = @blog.user

    load_post_groups
  end

  def create
    group_ids = params[:blog_post][:group_ids]
    group_ids.select! { |id| (id != '') && (can? :post_to, Group.find(id)) } if group_ids
    BlogPost.transaction do
      @blog_post = @blog.posts.build(params[:blog_post])
      @blog_post.user_id = current_user.id
      saved = @blog_post.save
      respond_to do |format|
        if saved
          NotificationBlogPostCreate.perform_async(@blog_post.id) unless @blog_post.draft?
          flash[:notice] = t('info.blog_created')
          format.html {
            if params[:group_id].to_s != ''
              @group = Group.find(params[:group_id])
              redirect_to group_url(@group)
            else
              redirect_to @blog
            end
          }
        else
          @user = @blog.user
          load_post_groups
          format.html { render action: "new" }
        end
      end
    end
  end

  def update
    @blog_post = @blog.posts.find(params[:id])
    if @blog_post.update_attributes(params[:blog_post])
      flash[:notice] = t('info.blog_post_updated')
      redirect_to([@blog, @blog_post])
    else
      render action: "edit"
    end
  end


  def destroy
    @blog_post = @blog.posts.find(params[:id])
    @blog_post.destroy
    flash[:notice] = t('info.blog_post_deleted')
    redirect_to @blog
  end

  private

  def choose_layout
    @group ? 'groups' : 'users'
  end

  def setup_image_template
    @empty_blog_post = BlogPost.new
  end


  protected

  def load_post_groups
    #can post only on groups where I'm allowed to
    @groups = current_user.groups
    .select('distinct groups.*')
    .joins("LEFT JOIN action_abilitations ON action_abilitations.group_id = groups.id")
    .where("(action_abilitations.group_id = groups.id " +
               " AND ((group_participations.participation_role_id = action_abilitations.participation_role_id " +
               " AND action_abilitations.group_action_id = 1)) or group_participations.participation_role_id = 2)")
  end

  def load_blog
    @blog = Blog.friendly.find(params[:blog_id]) if params[:blog_id]
    @user = @blog.user if @blog

    @group = (params[:group_id] && !params[:group_id].empty?) ? Group.friendly.find(params[:group_id]) : request.subdomain ? Group.find_by(subdomain: request.subdomain) : nil
    @groups = current_user.groups if current_user
  end

  def load_blog_post
    @blog_post = BlogPost.find(params[:id])
  end

  #reply if the user blog is not present
  def require_blog
    unless current_user.blog
      flash.now[:error] = t('error.blog_required')
      respond_to do |format|
        format.js { render 'layouts/error' }
        format.html do
          session[:blog_return_to] = request.url
          flash[:error] = t('error.blog_required')
          redirect_to new_blog_path
        end
      end
    end
  end

  def must_be_my_blog
    if @blog != current_user.blog
      flash.now[:error] = t('error.not_your_blog')
      respond_to do |format|
        format.js { render 'layouts/error' }
        format.html do
          flash[:error] = t('error.not_your_blog')
          if request.env["HTTP_REFERER"]
            redirect_to :back
          else
            redirect_to proposals_path
          end
        end
      end
    end
  end

  private

  def render_404(exception=nil)
    #log_error(exception) if exception
    respond_to do |format|
      @title = t('error.error_404.blog_posts.title')
      @message = t('error.error_404.blog_posts.description')
      format.html { render "errors/404", status: 404, layout: true }
    end
    true
  end
end
