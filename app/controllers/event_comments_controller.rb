#encoding: utf-8
class EventCommentsController < ApplicationController

  load_and_authorize_resource :event
  load_and_authorize_resource through: :event

  def create
    @event_comment.user = current_user
    @event_comment.request = request

    respond_to do |format|
      if @event_comment.save
        @event_comments = @event.event_comments.order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
        @saved = @event_comments.find { |comment| comment.id == @event_comment.id }
        @saved.collapsed = true
        notify_new_event_comment(@event_comment)
        flash[:notice] = t('info.event.comment_added')
        format.js
      else
        flash[:notice] = t('error.event.comment_added')
        format.js { render 'event_comments/errors/create'}
      end
    end
  end

  def destroy
    @event_comment.destroy
    flash[:notice] = 'The comment has been deleted'
    respond_to do |format|
      format.js {
          @event_comments = @event.event_comments.order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
      }
    end
  end

  def like
    (@event_comment.likers.include? current_user) ?
        @event_comment.likers.delete(current_user) :
        @event_comment.likers << current_user
    @event_comment.save!
    respond_to do |format|
      format.js { render 'layouts/success'}
    end
  end


  protected

  def event_comment_params
    params.require(:event_comment).permit(:parent_event_comment_id, :body)
  end
end
