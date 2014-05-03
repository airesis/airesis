#encoding: utf-8
class EventCommentLikesController < ApplicationController

  before_filter :authenticate_user!

  before_filter :load_event_comment
  before_filter :load_event_comment_like, only: :delete

  before_filter :check_author, :only => [:delete]


  def create
    @event_comment.likers << current_user
    @event_comment.save!
    respond_to do |format|
        format.js { render :update do |page|

        end
        }
    end
  end

  def delete
    @event_comment_like.destroy
    respond_to do |format|
      format.js {
        render :update do |page|
        end
      }
    end
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