#encoding: utf-8
class BlogPostsController < ApplicationController
  include NotificationHelper, GroupsHelper
  unloadable
  
  
  helper :blog
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:tag, :show]

  #l'utente deve aver creato un blog personale, oppure viene rimandato alla pagina per la creazione
  before_filter :require_blog, :except => [:index, :show, :tag]
  
  #before_filter :require_user, :except => [:index, :show, :tag]
  before_filter :load_blog, :except => [:tag]

  before_filter :load_blog_post, only: :show

  #il blog caricato deve essere dell'utente.
  #l'azione può essere eseguita solo sul proprio blog, altrimenti viene dato errore e redirezionato alla pagina precedente.
  before_filter :must_be_my_blog, :only => [:new, :edit, :update, :create, :destroy]
  
  

  before_filter :setup_image_template, :only => [:new, :edit, :create, :update]

  before_filter :check_page_alerts, only: :show
  
  layout :choose_layout
  
  def index    
    @blog_posts = @blog.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC') if @blog
    @group_posts = @group.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC') if @group
    
    @index_title = t('pages.blog_posts.index.title')
    
    respond_to do |format|
      format.html # index.html.erb    
      format.xml  { render :xml => @blog_posts }
      format.atom
    end
  end
  
  
  def drafts
    @page_title = t('pages.blog_posts.drafts.title', {blog: @blog.title})
    @user = @blog.user
    @blog_posts =  @blog.posts.drafts.paginate(:page => params[:page], :order => 'updated_at DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_posts }
    end
  end
  
  def show
    @user = @blog_post.user
    @page_title = @blog_post.title
    @blog_comment = @blog_post.blog_comments.new
    @blog_comments = @blog_post.blog_comments.includes(:user).paginate(:page => params[:page],:per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')
    respond_to do |format|
      format.js
      format.html
    end    
  end
  
  def new
    @blog_post = @blog.posts.build
    @blog_post.published = true
    
    load_post_groups
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @blog_post }
    end
  end
  
  def edit
    @blog_post = @blog.posts.find(params[:id])
    @user = @blog.user
    
    load_post_groups
  end
  
  def create
    group_ids = params[:blog_post][:group_ids]
    group_ids.select!{|id| can? :post_to, Group.find_by_id(id) } if group_ids
    BlogPost.transaction do
      @blog_post = @blog.posts.build(params[:blog_post])
      @blog_post.user_id = current_user.id
      
      saved = @blog_post.save
      
      respond_to do |format|
        if saved
          notify_user_insert_blog_post(@blog_post) if @blog_post.published
          flash[:notice] = t('info.blog_created')
          format.html {
            if params[:group_id] && !params[:group_id].empty?
              @group = Group.find(params[:group_id])
              redirect_to group_url(@group)
            else
              redirect_to([@blog,@blog_post])
            end
           }
          #format.xml  { render :xml => @blog_post, :status => :created, :location => @blog_post }
        else
          @user = @blog.user
          load_post_groups
          format.html { render :action => "new" }
          #format.xml  { render :xml => @blog_post.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def update
    @blog_post = @blog.posts.find(params[:id])
    
    respond_to do |format|
      if @blog_post.update_attributes(params[:blog_post])
        flash[:notice] = t('info.blog_post_updated')
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
    
    flash[:notice] = t('info.blog_post_deleted')
    
    respond_to do |format|
      format.html { redirect_to @blog }
      format.xml  { head :ok }
    end
  end
  
  private

  def choose_layout
    @group ? 'groups' : 'users'
  end
  
  def setup_image_template
    @empty_blog_post = BlogPost.new
    @empty_blog_post.blog_images.build
  end
  
  
  protected

  def load_post_groups
    #can post only on groups where I'm allowed to
    @groups = current_user.groups.all(
    :select => 'distinct groups.*', 
    :joins => "LEFT JOIN action_abilitations ON action_abilitations.group_id = groups.id", 
    :conditions => "(action_abilitations.group_id = groups.id " + 
                   " AND ((group_partecipations.partecipation_role_id = action_abilitations.partecipation_role_id " +
                   " AND action_abilitations.group_action_id = 1)) or group_partecipations.partecipation_role_id = 2)")
  end
  
  def load_blog   
    @blog = Blog.find(params[:blog_id])  if params[:blog_id]
    @user = @blog.user if @blog
         
    @group = (params[:group_id] && !params[:group_id].empty?) ? Group.find(params[:group_id]) : request.subdomain ? Group.find_by_subdomain(request.subdomain) : nil
    @groups = current_user.groups if current_user
  end

  def load_blog_post
    @blog_post = BlogPost.find(params[:id])
  end
  
  #reply if the user blog is not rpesent
  def require_blog
    unless current_user.blog
      respond_to do |format|
        format.js do
          flash.now[:error] = t('error.blog_required')
          render :update do |page|
             page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end  
        end
        format.html do   #vai alla pagina di ceazione blog
          session[:blog_return_to] = request.url
          flash[:error] = t('error.blog_required')
          redirect_to new_blog_path        
        end
      end
    end
  end
  
  def must_be_my_blog
    if @blog != current_user.blog
      respond_to do |format|
        format.js do
          flash.now[:error] = t('error.not_your_blog')
          render :update do |page|
             page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end  
        end
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
    log_error(exception) if exception
    respond_to do |format|
      @title = t('error.error_404.blog_posts.title')
      @message = t('error.error_404.blog_posts.description')
      format.html { render "errors/404", :status => 404, :layout => true }
    end
    true
  end
end
