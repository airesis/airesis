class EventCommentLikesController < ApplicationController
  before_action :authenticate_user!

  before_action :load_event_comment
  before_action :load_event_comment_like, only: :delete

  before_action :check_author, only: [:delete]

  def create
    @event_comment.likers << current_user
    @event_comment.save!
    respond_to do |format|
      format.js { render 'layouts/success' }
    end
  end

  def delete
    @event_comment_like.destroy
    format.js { render 'layouts/success' }
  end

  private

  def load_event_comment
    @event_comment = EventComment.find(params[:event_comment_id])
  end

  def load_event_comment_like
    @event_comment_like = @event_comment.likes.find(params[:event_comment_like_id])
  end

  def check_author
    if current_user.id != @event_comment_like.user_id
      flash[:error] = t('info.proposal.comment_not_your')
      redirect_to :back
    end
  end
end
