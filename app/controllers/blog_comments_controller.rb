class BlogCommentsController < ApplicationController
  layout('application')

  before_action :save_comment, only: :create

  load_and_authorize_resource :blog
  load_and_authorize_resource :blog_post
  load_and_authorize_resource through: :blog_post

  def index
    register_view(current_user)
  end

  def create
    respond_to do |format|
      if save_blog_comment(@blog_comment)
        flash[:notice] = t('info.blog.comment_added')
        @blog_comment.collapsed = true
        format.html
        format.js
      else
        flash[:error] = t('error.blog.comment_added')
        format.html
        format.js { render 'blog_comments/errors/create' }
      end
    end
  end

  def destroy
    @blog_comment.destroy
    flash[:notice] = t('info.blog_comment.destroyed')
    respond_to do |format|
      format.html { redirect_to blog_blog_post_url(@blog, @blog_post) }
      format.js
    end
  end

  private

  def blog_comment_params
    params.require(:blog_comment).permit(:parent_blog_comment_id, :body)
  end

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
    if current_user.id != @blog_comment.user_id &&
        current_user.id != @blog_post.user_id
      flash[:notice] = t('info.proposal.comment_not_your')
      redirect_back(fallback_location: blog_post_path(@blog_post))
    end
  end

  def save_comment
    return if current_user
    session[:blog_comment] = blog_comment_params
    session[:blog_post_id] = params[:blog_post_id]
    session[:blog_id] = params[:blog_id]
    flash[:info] = t('info.proposal.login_to_contribute')
  end
end
