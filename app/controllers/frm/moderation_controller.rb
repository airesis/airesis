module Frm
  class ModerationController < Frm::ApplicationController
    before_action :ensure_moderator_or_admin

    helper 'frm/posts'

    def index
      @posts = forum.posts.pending_review.topic_not_pending_review
      @topics = forum.topics.pending_review
    end

    def posts
      Frm::Post.moderate!(params[:posts] || [])
      flash[:notice] = t('frm.posts.moderation.success')
      redirect_back(fallback_location: root_path)
    end

    def topic
      if params[:topic]
        topic = forum.topics.friendly.find(params[:topic_id])
        topic.moderate!(params[:topic][:moderation_option])
        flash[:notice] = t('frm.topic.moderation.success')
      else
        flash[:error] = t('frm.topic.moderation.no_option_selected')
      end
      redirect_back(fallback_location: root_path)
    end

    private

    def forum
      @forum = @group.forums.friendly.find(params[:forum_id])
    end

    helper_method :forum

    def ensure_moderator_or_admin
      raise CanCan::AccessDenied unless forem_admin?(@group) || forum.moderator?(current_user)
    end
  end
end
