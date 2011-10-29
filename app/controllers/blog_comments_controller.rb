#encoding: utf-8
class BlogCommentsController < ApplicationController
  unloadable
  
  helper :blog
  
  layout('application')
  
  #before_filter :require_user, :only => [:destroy]
  #before_filter :require_admin, :only => [:destroy]
  before_filter :require_blog_post #carica @blog e @blog_post
  before_filter :require_blog_comment, :only => [:destroy,:ajaxdestroy] #carica @blog_comment
  
  before_filter :login_required, :only => [:create, :destroy,:ajaxdestroy]
  before_filter :check_author, :only => [:destroy,:ajaxdestroy]
  
  
  def index
    
    
  end
  
  def check_author
    if (current_user.id != @blog_comment.user_id and
        current_user.id != @blog_post.user_id)    
      flash[:notice] = t(:error_comment_not_your)
      redirect_to :back
    end
    
  end
  

  def create
    @blog_comment = @blog_post.blog_comments.new(params[:blog_comment])
    @blog_comment.user_id = current_user.id if current_user
    @blog_comment.request = request
    
    respond_to do |format|
      if @blog_comment.save
        flash[:notice] = 'Commento inserito.'      
        @blog_comments = @blog_post.blog_comments.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE,:order => 'created_at DESC')
        @saved = @blog_comments.find { |comment| comment.id == @blog_comment.id }
        @saved.collapsed = true
        format.html 
        format.js   { render :update do |page|
                        page.replace_html "blogPostCommentsContainer", :partial => "blog_posts/comments", :layout => false
                        page.replace "blogNewComment", :partial => 'blog_comments/new_blog_comment', :locals => {:blog_comment => @blog_post.blog_comments.new}
                        
                      end
                      #render :partial => "blog_posts/comments", :layout => false
                    }
        
        format.xml  { render :xml => @blog_comment, :status => :created, :location => @blog_comment }
      else        
        format.html 
        format.js   { render :update do |page|
                        page.replace "blogNewComment", :partial => 'blog_comments/new_blog_comment', :locals => {:blog_comment => @blog_comment}
                      end
                    }
        format.xml  { render :xml => @blog_comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
          
    @blog_comment.destroy
    
    flash[:notice] = 'The comment has been deleted'
    
    respond_to do |format|
      format.html { redirect_to(blog_blog_post_url(@blog,@blog_post)) }
      format.xml  { head :ok }
    end
  end
  
  def ajaxdestroy
       
    @blog_comment.destroy
    
    @blog_comments = @blog_post.blog_comments.paginate(:page => params[:page],:per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')
    
    flash[:notice] = 'The comment has been deleted'
    
    render :partial => "blog_posts/comments", :layout => false
  end
  
  
  private
  def require_blog_post
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog = @blog_post.blog
    
    unless @blog_post
      flash[:notice] = 'The post you were looking for could not be found'
      redirect_to :controller => 'blog_posts'
      return false
    end
    
    return true
  end
  
  def require_blog_comment
    @blog_comment = BlogComment.find(params[:id])
    true
  end
  
  
  def require_admin
    if !current_user || !current_user.admin?
      flash[:notice] = 'You must be an admin to view this page'
      redirect_to blog_posts_path
      return false
    end
    
    return true
  end
end