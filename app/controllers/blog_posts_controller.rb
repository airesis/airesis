#encoding: utf-8
class BlogPostsController < ApplicationController
  unloadable
  
  helper :blog
  
  layout :choose_layout
  
  #before_filter :require_user, :except => [:index, :show, :tag]
  before_filter :load_blog, :except => [:tag]
  #before_filter :require_admin, :except => [:index, :show, :tag]
  before_filter :setup_image_template, :only => [:new, :edit, :create, :update]
  
  def load_blog
    @blog = Blog.find(params[:blog_id])
    @groups = current_user.groups if current_user
  end
  
  def index
    @blog_posts = @blog.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC')
    @index_title = BlogKit.instance.settings['blog_name'] || 'Blog'
    
    respond_to do |format|
      format.html # index.html.erb    
      format.xml  { render :xml => @blog_posts }
      format.atom
    end
  end
  
  def tag
    @tag = params[:id]
    @blog_post_tags = BlogPostTag.find_all_by_tag(params[:id])
    
    if @blog_post_tags.size > 0
      @blog_posts =  BlogPost.published.paginate(:page => params[:page], :conditions => ['id IN (?)', @blog_post_tags.map(&:blog_post_id)], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC')
    else
      @blog_posts = []
    end
    
    @index_title = 'Tag: ' + @tag
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @blog_posts }
    end		
  end
  
  def drafts
    @blog_posts =  @blog.posts.drafts.paginate(:page => params[:page], :order => 'updated_at DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_posts }
    end
  end
  
  def show
    @blog_post = @blog.posts.find(params[:id])
    @blog_comment = @blog_post.blog_comments.new
    @blog_comments = @blog_post.blog_comments.paginate(:page => params[:page],:per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')    
  end
  
  def new
    @blog_post = @blog.posts.build
    @groups = current_user.groups
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog_post }
    end
  end
  
  def edit
    @blog_post = @blog.posts.find(params[:id])
  end
  
  def create
    
    BlogPost.transaction do
      @blog_post = @blog.posts.build(params[:blog_post])
      @blog_post.user_id = current_user.id
      
      saved = @blog_post.save
      
      respond_to do |format|
        if saved
          flash[:notice] = 'Il tuo post #{blog_post.id} è stato creato correttamente.'
          format.html { redirect_to([@blog,@blog_post]) }
          format.xml  { render :xml => @blog_post, :status => :created, :location => @blog_post }
        else
          
          format.html { render :action => "new" }
          format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def update
    @blog_post = @blog.posts.find(params[:id])
    
    respond_to do |format|
      if @blog_post.update_attributes(params[:blog_post])
        flash[:notice] = 'Il tuo post è stato aggiornato correttamente.'
        format.html { redirect_to([@blog,@blog_post]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
    @blog_post = @blog.posts.find(params[:id])
    @blog_post.destroy
    
    flash[:notice] = 'Il tuo post è stato cancellato correttamente.'
    
    respond_to do |format|
      format.html { redirect_to(blog_blog_posts_url(@blog)) }
      format.xml  { head :ok }
    end
  end
  
  private
  def require_admin
    if !current_user || !current_user.admin?
      flash[:notice] = 'Devi essere amministratore per visualizzare questa pagina.'
      redirect_to blog_path(@blog)
      return false
    end
    
    return true
  end
  
  def choose_layout
    if ['new', 'edit', 'create', 'update'].include?(params[:action])
      BlogKit.instance.settings['admin_layout'] || 'application'
    else
      BlogKit.instance.settings['layout'] || 'application'
    end
  end
  
  def setup_image_template
    @empty_blog_post = BlogPost.new
    @empty_blog_post.blog_images.build
  end
end
