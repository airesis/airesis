#encoding: utf-8
class BlogCommentsController < ApplicationController
  helper :blog
  
  layout('application')
    
  before_filter :authenticate_user!, only: [:create, :delete]
  before_filter :load_blog_post
  before_filter :load_blog_comment, only: [:delete]
  before_filter :check_author, only: [:delete]
  
  def index
  
  end
  
  def create
    @blog_comment = @blog_post.blog_comments.new(params[:blog_comment])
    @blog_comment.user_id = current_user.id if current_user
    @blog_comment.request = request
    
    respond_to do |format|
      if @blog_comment.save
        flash[:notice] = t('info.blog.comment_added')
        @blog_comments = @blog_post.blog_comments.order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
        @saved = @blog_comments.find { |comment| comment.id == @blog_comment.id }
        @saved.collapsed = true
        NotificationBlogCommentCreate.perform_async(@blog_comment.id)
        format.js
        format.html
      else
        flash[:notice] = t('error.blog.comment_added')
        format.js { render 'blog_comments/errors/create'}
        format.html 
      end
    end
  end
  
  def delete       
    @blog_comment.destroy  
    flash[:notice] = 'The comment has been deleted'  
    respond_to do |format|
      format.js {
        @blog_comments = @blog_post.blog_comments.order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
      }
      format.html { redirect_to(blog_blog_post_url(@blog,@blog_post)) }
    end
  end
  
 
  private
  def load_blog_post
    @blog_post = BlogPost.find(params[:blog_post_id])
    @blog = @blog_post.blog
    
    unless @blog_post
      flash[:notice] = 'The post you were looking for could not be found'
      redirect_to controller: 'blog_posts'
      return false
    end
    
    true
  end
  
  def load_blog_comment
    @blog_comment = BlogComment.find(params[:id])
    true
  end
  
   def check_author
    if (current_user.id != @blog_comment.user_id and
        current_user.id != @blog_post.user_id)    
      flash[:notice] = t('info.proposal.comment_not_your')
      redirect_to :back
    end
    
  end
  
end