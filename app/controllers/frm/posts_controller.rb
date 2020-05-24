# TODO: refactor and use cancan
module Frm
  class PostsController < Frm::ApplicationController
    load_and_authorize_resource :forum, class: 'Frm::Forum', through: :group
    load_and_authorize_resource :topic, class: 'Frm::Topic', through: :forum
    load_and_authorize_resource through: :topic

    before_action :reject_locked_topic!, only: [:create]
    before_action :authorize_reply_for_topic!, only: [:new, :create]
    before_action :authorize_edit_post_for_forum!, only: [:edit, :update]

    def new
      find_reply_to_post
      if params[:quote]
        if @reply_to_post
          @post.text = view_context.forem_quote(@reply_to_post.text)
        else
          flash[:notice] = t('frm.post.cannot_quote_deleted_post')
          redirect_to group_forum_topic_url(@group, @forum, @topic)
        end
      end
    end

    def create
      @post.user = current_user

      if @post.save
        create_successful
      else
        Rails.logger.error("Error while creating a Frm::Post. #{@post.errors.details}")
        create_failed
      end
    end

    def edit
    end

    def update
      if @post.owner_or_moderator?(current_user) && @post.update(post_params)
        update_successful
      else
        update_failed
      end
    end

    def destroy
      @post.destroy
      destroy_successful
    end

    protected

    def post_params
      params.require(:frm_post).permit(:text, :reply_to_id)
    end

    private

    def authorize_reply_for_topic!
      authorize! :reply, @topic
    end

    def authorize_edit_post_for_forum!
      authorize! :edit_post, @topic.forum
    end

    def create_successful
      flash[:notice] = t('frm.post.created')
      redirect_to group_forum_topic_url(@group, @topic.forum, @topic, page: @topic.last_page)
    end

    def create_failed
      params[:reply_to_id] = params[:frm_post][:reply_to_id]
      flash.now.alert = t('frm.post.not_created')
      render action: 'new'
    end

    def destroy_successful
      if @post.topic.posts.empty?
        @post.topic.destroy
        flash[:notice] = t('frm.post.deleted_with_topic')
        redirect_to group_forum_path(@group, @topic.forum)
      else
        flash[:notice] = t('frm.post.deleted')
        redirect_to group_forum_topic_path(@group, @topic.forum, @topic)
      end
    end

    def update_successful
      redirect_to group_forum_topic_url(@group, @topic.forum, @topic), notice: t('edited', scope: 'frm.post')
    end

    def update_failed
      flash.now.alert = t('frm.post.not_edited')
      render action: 'edit'
    end

    def reject_locked_topic!
      if @topic.locked?
        flash.alert = t('frm.post.not_created_topic_locked')
        redirect_to(group_forum_topic_url(@group, @topic.forum, @topic)) && return
      end
    end

    def find_reply_to_post
      @reply_to_post = @topic.posts.find_by(id: params[:reply_to_id])
    end
  end
end
