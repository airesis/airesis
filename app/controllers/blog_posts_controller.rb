#encoding: utf-8
class BlogPostsController < ApplicationController
  include NotificationHelper
  unloadable
  
  
  helper :blog
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:tag, :show]

  #l'utente deve aver creato un blog personale, oppure viene rimandato alla pagina per la creazione
  before_filter :require_blog, :except => [:index, :show, :tag]
  
  #before_filter :require_user, :except => [:index, :show, :tag]
  before_filter :load_blog, :except => [:tag]

  #il blog caricato deve essere dell'utente.
  #l'azione può essere eseguita solo sul proprio blog, altrimenti viene dato errore e redirezionato alla pagina precedente.
  before_filter :must_be_my_blog, :only => [:new, :edit, :update, :create, :destroy]
  
  
  #before_filter :require_admin, :except => [:index, :show, :tag]
  before_filter :setup_image_template, :only => [:new, :edit, :create, :update]
  
  layout :choose_layout
  
  def index    
    @blog_posts = @blog.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC') if @blog
    @group_posts = @group.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC') if @group
    
    @index_title = 'Blog'
    
    respond_to do |format|
      format.html # index.html.erb    
      format.xml  { render :xml => @blog_posts }
      format.atom
    end
  end
  
  
  def drafts
    @page_title = @blog.title + " - post non pubblicati"
    @user = @blog.user
    @blog_posts =  @blog.posts.drafts.paginate(:page => params[:page], :order => 'updated_at DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_posts }
    end
  end
  
  def show
    @blog_post = BlogPost.find(params[:id])
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
            redirect_to group_path(params[:group_id]) if (params[:group_id] && !params[:group_id].empty?)               
            redirect_to([@blog,@blog_post]) if (!params[:group_id] || params[:group_id].empty?) 
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
      format.html { redirect_to :back || @blog }
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
    @group ? 'groups' : 'users'
  end
  
  def setup_image_template
    @empty_blog_post = BlogPost.new
    @empty_blog_post.blog_images.build
  end
  
  
  protected

  def load_post_groups
    #posso postare nei gruppi per i quali ho il permesso (numero 1)
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
         
    @group = Group.find(params[:group_id]) unless params[:group_id].blank?
    @groups = current_user.groups if current_user
    #if !@blog
    #  blog_required
    #end
  end
  
  #risposta nel caso non sia presente il blog dell'utente
  def require_blog
    if (!current_user.blog)
      respond_to do |format|
        format.js do        #se era una chiamata ajax, mostra il messaggio
          flash.now[:notice] = t('error.blog_required')
          render :update do |page|
             page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end  
        end
        format.html do   #vai alla pagina di ceazione blog
          session[:blog_return_to] = request.url
          flash[:notice] = t('error.blog_required')
          redirect_to new_blog_path        
        end
      end
    end
  end
  
  def must_be_my_blog
    if (@blog != current_user.blog)
      respond_to do |format|
        format.js do        #se era una chiamata ajax, mostra il messaggio
          flash.now[:error] = t('error.not_your_blog')
          render :update do |page|
             page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end  
        end
        format.html do   #vai alla pagina di ceazione blog          
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
end
