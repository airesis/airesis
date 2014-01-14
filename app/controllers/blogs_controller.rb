#encoding: utf-8
class BlogsController < ApplicationController
  # GET /blogs
  # GET /blogs.xml
  layout :choose_layout


  before_filter :load_blog, only: [:show,:by_year_and_month]
  before_filter :load_blog_data, only: [:show,:by_year_and_month]
  
  before_filter :authenticate_user!, :only => [ :edit, :update, :destroy, :new, :create ]
  before_filter :check_author, :only => [:edit, :update, :destroy]
  
  
   def check_author
    @blog = Blog.find(params[:id])
    if !(current_user.is_my_blog? @blog.id) && !is_admin?
      flash[:notice] = t('error.blog.cannot_edit')
      redirect_to :back
    end
   end
  
  def index
    @page_title = t('pages.blogs.show.title')
    @blogs = Blog.select('blogs.*, count(blog_posts.id) as posts_count, count(blog_comments.id) as comments_count').joins(:posts => :blog_comments).group('blogs.id, blogs.user_id, blogs.title').page(params[:page]).per(10)
    respond_to do |format|
      format.js
      format.xml  { render :xml => @blogs }
      format.html
    end
  end
  
  # GET /blogs/1
  # GET /blogs/1.xml
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
      format.xml  { render :xml => @blog_posts }
      format.html # index.html.erb
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    if current_user.blog
      flash[:error] = t('error.blog.already_have')
      redirect_to root_path
    else
      @user = current_user
      @blog = Blog.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @blog }
      end
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = Blog.find(params[:id])
    @user = @blog.user
  end

  # POST /blogs
  # POST /blogs.xml
  def create
    
    params[:blog][:user_id] = current_user.id
    @blog = Blog.new(params[:blog])

    respond_to do |format|
      if @blog.save
        flash[:notice] = t('info.blog.blog_created')
        format.html {
          if session[:blog_return_to]
            redirect_to session[:blog_return_to]
          else
            redirect_to(@blog) 
          end
        }
        #format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = t('info.blog.title_updated')
        format.html { redirect_to(@blog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
  
  protected


  def load_blog
    @blog = Blog.find(params[:id])
    @user = @blog.user
    @blog_posts = @blog.posts.published.includes(:user,:blog,:tags).order('published_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
    @recent_comments =  @blog.comments.order('created_at DESC').limit(10)
    @recent_posts =  @blog.posts.published.order('published_at DESC').limit(10)
    @archives = @blog.posts.select("COUNT(*) AS posts, extract(month from created_at) AS MONTH , extract(year from created_at) AS YEAR").group("MONTH, YEAR").order("YEAR desc, extract(month from created_at) desc")
  end


  
  def choose_layout
    params[:action] == 'index' ? 'open_space' : 'users'
  end
  
  
end
