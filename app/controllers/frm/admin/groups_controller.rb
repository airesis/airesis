module Frm
  module Admin
    class GroupsController < BaseController

      before_filter :find_group, :only => [:show, :destroy]

      def index
        @frm_groups = @group.moderator_groups.all
      end

      def new
        @page_title = t("frm.admin.group.new")
        @frm_group = @group.moderator_groups.build
      end

      def create
        @frm_groups = @group.moderator_groups
        @frm_group = @frm_groups.build(params[:frm_group])
        if @frm_group.save
          flash[:notice] = t("frm.admin.group.created")
          respond_to do |format|
            format.html {
              redirect_to group_frm_admin_frm_group_url(@group, @frm_group)
            }
            format.js
          end
        else
          flash[:alert] = t("frm.admin.group.not_created")
          render :new
        end
      end

      def destroy
        @frm_group.destroy
        flash[:notice] = t("frm.admin.group.deleted")
        redirect_to group_frm_admin_frm_groups_url(@group)
      end

      private

      def find_group
        @frm_group = Frm::Group.find(params[:id])
      end
    end
  end
end
