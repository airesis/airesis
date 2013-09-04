module Frm
  module Admin
    class GroupsController < BaseController

      before_filter :find_group, :only => [:show, :destroy]

      def index
        @frm_groups = Frm::Group.all
      end

      def new
        @frm_group = Frm::Group.new
      end

      def create
        @frm_group = Frm::Group.new(params[:frm_group])
        if @frm_group.save
          flash[:notice] = t("forem.admin.group.created")
          redirect_to group_frm_admin_group_url(@group,@frm_group)
        else
          flash[:alert] = t("forem.admin.group.not_created")
          render :new
        end
      end

      def destroy
        @frm_group.destroy
        flash[:notice] = t("forem.admin.group.deleted")
        redirect_to group_frm_admin_groups_url(@group)
      end

      private

        def find_group
          @frm_group = Frm::Group.find(params[:id])
        end
    end
  end
end
