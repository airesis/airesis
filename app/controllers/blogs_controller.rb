#encoding: utf-8
class BlogsController < ApplicationController
  layout :choose_layout

  load_and_authorize_resource

  before_filter :load_blog_data, only: [:show, :edit, :by_year_and_month]

  def index
    @tags = Tag.most_blogs(current_domain.territory).shuffle unless request.xhr?
    @page_title = t('pages.blogs.show.title')

    params[:interest_border_obj] = @interest_border = if params[:interest_border].nil?
                                                        InterestBorder.find_or_create_by(territory: current_domain.territory)
                                                      else
                                                        InterestBorder.find_or_create_by_key(params[:interest_border])
                                                      end
    @blogs = Blog.look(params)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @page_title = @blog.title
    @blog_posts = @blog_posts.published.page(params[:page]).per(COMMENTS_PER_PAGE)
    respond_to do |format|
      format.html
      format.js
      format.atom
      format.json
    end
  end

  def by_year_and_month
    @page_title = t('pages.blog_posts.archives.title', year: params[:year], month: t('date.month_names')[params[:month].to_i])
    @blog_posts = @blog_posts.published.where("extract(year from created_at) = ? AND extract(month from created_at) = ? ", params[:year], params[:month]).order("created_at DESC").page(params[:page]).per(COMMENTS_PER_PAGE)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    if current_user.blog
      flash[:error] = t('error.blog.already_have')
      redirect_to root_path
    else
      @user = current_user
      @blog.user = current_user

      respond_to do |format|
        format.html # new.html.erb
      end
    end
  end

  def edit
    @user = @blog.user
  end

  def create
    @blog.user = current_user
    if @blog.save
      flash[:notice] = t('info.blog.blog_created')
      if session[:blog_return_to]
        redirect_to session[:blog_return_to]
      else
        redirect_to @blog
      end
    else
      @user = current_user
      render action: "new"
    end
  end

  def update
    if @blog.update_attributes(blog_params)
      flash[:notice] = t('info.blog.title_updated')
      redirect_to @blog
    else
      render action: "edit"
    end
  end

  def destroy
    @blog = Blog.friendly.find(params[:id])
    @blog.destroy
    redirect_to blogs_url
  end

  protected

  def blog_params
    params.require(:blog).permit(:title)
  end

  def load_blog
    @blog = Blog.friendly.find(params[:id])
  end

  def choose_layout
    params[:action] == 'index' ? 'open_space' : 'users'
  end
end
