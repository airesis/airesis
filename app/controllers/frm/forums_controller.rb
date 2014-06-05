module Frm
  class ForumsController < Frm::ApplicationController

    #load_and_authorize_resource class: 'Frm::Forum', only: :show

    #before_filter :check_permissions
    before_filter :load_forum, only: :show

    helper 'frm/topics'

    layout 'groups'

    def index
      @categories = @group.categories.load
    end

    def show
      authorize! :read, @forum
      register_view

      @topics = if forem_admin_or_moderator?(@forum)
        @forum.topics
      else
        @forum.topics.visible.approved_or_pending_review_for(current_user)
      end

      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(TOPICS_PER_PAGE)

      respond_to do |format|
        format.html
        format.atom { render layout: false }
      end
    end

    private

    #def check_permissions
    #  raise CanCan::AccessDenied unless @group.participants.include? current_user
    #end

    def register_view
      @forum.register_view_by(current_user)
    end


    def load_forum
      @forum = @group.forums.friendly.find(params[:id])
    end
  end
end
