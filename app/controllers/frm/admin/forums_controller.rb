module Frm
  module Admin
    class ForumsController < BaseController



      before_filter :load_group
      before_filter :find_forum, only: [:edit, :update, :destroy]

      def index
        @forums = @group.forums.all
      end

      def new
        @forum = @group.forums.build
        category = @group.categories.first
        @forum.category = category
        @forum.tags = category.tags
      end

      def create
        @forum = Frm::Forum.new(params[:frm_forum])
        @forum.group_id = @group.id
        if @forum.save
          create_successful
        else
          create_failed
        end
      end

      def update
        if @forum.update_attributes(params[:frm_forum])
          update_successful
        else
          update_failed
        end
      end

      def destroy
        @forum.destroy
        destroy_successful
      end

      private

      def find_forum
        @forum = @group.forums.find(params[:id])
      end

      def create_successful
        flash[:notice] = t("frm.admin.forum.created")
        redirect_to group_frm_admin_forums_url(@group)
      end

      def create_failed
        flash.now.alert = t("frm.admin.forum.not_created")
        render action: "new"
      end

      def destroy_successful
        flash[:notice] = t("frm.admin.forum.deleted")
        redirect_to group_frm_admin_forums_url(@group)
      end

      def update_successful
        flash[:notice] = t("frm.admin.forum.updated")
        redirect_to group_frm_admin_forums_url(@group)
      end

      def update_failed
        flash.now.alert = t("frm.admin.forum.not_updated")
        render action: "edit"
      end

    end
  end
end
