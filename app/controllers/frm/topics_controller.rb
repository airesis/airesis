module Frm
  class TopicsController < Frm::ApplicationController
    helper 'frm/posts'

    load_and_authorize_resource :forum, class: 'Frm::Forum', through: :group
    load_and_authorize_resource through: :forum

    def show
      if find_topic
        flash[:warn] = t('info.topic.hidden') if @topic.hidden
        register_view(@topic, current_user)
        @posts = find_posts(@topic).page(params[:page]).per(TOPICS_PER_PAGE)
      end
    end

    def new
      authorize! :create_topic, @forum
      @topic.posts.build
    end

    def create
      authorize! :create_topic, @forum
      @topic.user = current_user
      if @topic.save
        create_successful
      else
        create_unsuccessful
      end
    end

    def destroy
      if current_user == @topic.user || current_user.forem_admin?(@group)
        @topic.destroy
        destroy_successful
      else
        destroy_unsuccessful
      end
    end

    def subscribe
      if find_topic
        @topic.subscribe_user(current_user.id)
        subscribe_successful
      end
    end

    def unsubscribe
      if find_topic
        @topic.unsubscribe_user(current_user.id)
        unsubscribe_successful
      end
    end

    protected
    def create_successful
      redirect_to group_forum_topic_url(@group, @forum, @topic), notice: t("frm.topic.created")
    end

    def create_unsuccessful
      flash.now.alert = t('frm.topic.not_created')
      render action: 'new'
    end

    def destroy_successful
      flash[:notice] = t("frm.topic.deleted")

      redirect_to group_forum_url(@group, @topic.forum)
    end

    def destroy_unsuccessful
      flash.alert = t("frm.topic.cannot_delete")

      redirect_to group_forum_url(@group, @topic.forum)
    end

    def subscribe_successful
      flash[:notice] = t("frm.topic.subscribed")
      respond_to do |format|
        format.html {
          redirect_to group_forum_topic_url(@group, @topic.forum, @topic)
        }
        format.js {
          render 'subscribe'
        }
      end
    end

    def unsubscribe_successful
      flash[:notice] = t("frm.topic.unsubscribed")
      respond_to do |format|
        format.html {
          redirect_to group_forum_topic_url(@group, @topic.forum, @topic)
        }
        format.js {
          render 'subscribe'
        }
      end
    end


    protected


    def load_forum
      @forum = @group.forums.friendly.find(params[:forum_id])
    end

    def topic_params
      params.require(:frm_topic).permit(:subject, :tags_list, posts_attributes: [:text])
    end


    def find_posts(topic)
      posts = topic.posts
      unless forem_admin_or_moderator?(topic.forum)
        posts = posts.approved_or_pending_review_for(current_user)
      end
      @posts = posts
    end

    def find_topic
      begin
        @topic = forum_topics(@forum, current_user).friendly.find(params[:id])
        authorize! :read, @topic
      rescue ActiveRecord::RecordNotFound
        flash.alert = t("frm.topic.not_found")
        redirect_to group_forum_url(@group, @forum) and return
      end
    end

    def register_view(topic, user)
      topic.register_view_by(user)
    end

    def forum_topics(forum, user)
      if forem_admin_or_moderator?(forum)
        forum.topics
      else
        forum.topics.visible(user).approved_or_pending_review_for(user)
      end
    end
  end
end
