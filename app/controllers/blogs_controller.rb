#encoding: utf-8
class BlogsController < ApplicationController
  layout :choose_layout


  before_filter :load_blog, only: [:show, :by_year_and_month]
  before_filter :load_blog_data, only: [:show, :by_year_and_month]

  before_filter :authenticate_user!, :only => [:edit, :update, :destroy, :new, :create]
  before_filter :check_author, :only => [:edit, :update, :destroy]


  def check_author
    @blog = Blog.friendly.find(params[:id])
    if !(current_user.is_my_blog? @blog.id) && !is_admin?
      flash[:notice] = t('error.blog.cannot_edit')
      redirect_to :back
    end
  end

  def index
    unless request.xhr?
      @tags = Tag.most_blogs.shuffle
    end
    @page_title = t('pages.blogs.show.title')
    @blogs = Blog.look(params)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    respond_to do |format|
      format.js {
        @blog_posts = @blog_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
      }
      format.html {
        @page_title = @blog.title
        @blog_posts = @blog_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
      }
      format.atom
      format.json
    end
  end


  def by_year_and_month
    @page_title = t('pages.blog_posts.archives.title', year: params[:year], month: t('date.month_names')[params[:month].to_i])
    @blog_posts = @blog.posts.where("extract(year from created_at) = ? AND extract(month from created_at) = ? ", params[:year], params[:month]).order("created_at DESC").page(params[:page]).per(COMMENTS_PER_PAGE)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    if current_user.blog
      flash[:error] = t('error.blog.already_have')
      redirect_to root_path
    else
      @user = current_user
      @blog = Blog.new

      respond_to do |format|
        format.html # new.html.erb
      end
    end
  end

  def edit
    @blog = Blog.friendly.find(params[:id])
    @user = @blog.user
  end

  def create
    params[:blog][:user_id] = current_user.id
    @blog = Blog.new(params[:blog])
    if @blog.save
      flash[:notice] = t('info.blog.blog_created')
      if session[:blog_return_to]
        redirect_to session[:blog_return_to]
      else
        redirect_to @blog
      end

    else
      render :action => "new"
    end
  end

  def update
    @blog = Blog.friendly.find(params[:id])
    if @blog.update_attributes(params[:blog])
      flash[:notice] = t('info.blog.title_updated')
      redirect_to @blog
    else
      render :action => "edit"
    end
  end

  def destroy
    @blog = Blog.friendly.find(params[:id])
    @blog.destroy
    redirect_to blogs_url
  end

  protected

  def load_blog
    @blog = Blog.friendly.find(params[:id])
    @user = @blog.user
    @blog_posts = @blog.posts.published.includes(:user, :blog, :tags).order('published_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
    @recent_comments = @blog.comments.order('created_at DESC').limit(10)
    @recent_posts = @blog.posts.published.order('published_at DESC').limit(10)
    @archives = @blog.posts.select("COUNT(*) AS posts, extract(month from created_at) AS MONTH , extract(year from created_at) AS YEAR").group("MONTH, YEAR").order("YEAR desc, extract(month from created_at) desc")
  end

  def choose_layout
    params[:action] == 'index' ? 'open_space' : 'users'
  end
end
