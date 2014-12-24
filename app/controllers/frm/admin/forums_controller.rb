module Frm
  module Admin
    class ForumsController < BaseController

      load_and_authorize_resource :group
      load_and_authorize_resource class: 'Frm::Forum', through: :group

      def index
      end

      def new
        category = @group.categories.first
        @forum.category = category
        @forum.tags = category.tags
      end

      def create
        if @forum.save
          create_successful
        else
          create_failed
        end
      end

      def update
        if @forum.update_attributes(frm_forum_params)
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

      def forum_params
        params.require(:frm_forum).permit(:category_id, :title, :name, :description, :moderator_ids, :visible_outside, :tags_list)
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
