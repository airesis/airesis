#encoding: utf-8
class EventCommentsController < ApplicationController


  before_filter :authenticate_user!, :only => [:create, :delete, :edit, :update]

  before_filter :load_event
  before_filter :load_event_comment, :only => [:delete, :edit, :update, :like] #carica @blog_comment
  before_filter :check_author, :only => [:delete, :edit, :update]


  def create
    @event_comment = @event.comments.new(params[:event_comment])
    @event_comment.user_id = current_user.id if current_user
    @event_comment.request = request

    respond_to do |format|
      if @event_comment.save
        flash[:notice] = t('info.event.comment_added')
        @event_comments = @event.comments.order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
        @saved = @event_comments.find { |comment| comment.id == @event_comment.id }
        @saved.collapsed = true
        notify_new_event_comment(@event_comment)
        format.js { render :update do |page|
          page.replace_html "eventCommentsContainer", :partial => "events/comments", :layout => false
          page.replace "eventNewComment", :partial => 'event_comments/new_event_comment', :locals => {:event_comment => @event.comments.new}

        end
        }
      else
        flash[:notice] = t('error.event.comment_added')
        format.js { render :update do |page|
          page.replace "eventNewComment", :partial => 'event_comments/new_event_comment', :locals => {:event_comment => @event_comment}
        end
        }
      end
    end
  end

  def delete
    @event_comment.destroy
    flash[:notice] = 'The comment has been deleted'
    respond_to do |format|
      format.js {
        render :update do |page|
          @event_comments = @event.comments.order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
          page.replace_html "eventCommentsContainer", :partial => "events/comments"
        end
      }
    end
  end


  def like

    (@event_comment.likers.include? current_user) ?
        @event_comment.likers.delete(current_user) :
        @event_comment.likers << current_user
    @event_comment.save!
    respond_to do |format|
      format.js { render :update do |page|

      end
      }
    end
  end


  private
  def load_event
    @event = Event.find(params[:event_id])
  end

  def load_event_comment
    @event_comment = EventComment.find(params[:id])
    true
  end

  def check_author
    if current_user.id != @event_comment.user_id
      flash[:error] = t('info.proposal.comment_not_your')
      redirect_to :back
    end
  end
end