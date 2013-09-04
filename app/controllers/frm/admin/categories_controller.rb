module Frm
  module Admin
    class CategoriesController < BaseController

      before_filter :find_category, :only => [:edit, :update, :destroy]

      def index
        @category = Frm::Category.all
      end

      def new
        @category =  Frm::Category.new
      end

      def create
        @category = Frm::Category.new(params[:frm_category])
        @category.group_id = @group.id
        if @category.save
          create_successful
        else
          create_failed
        end
      end

      def update
        if @category.update_attributes(params[:category])
          update_successful
        else
          update_failed
        end
      end

      def destroy
        @category.destroy
        destroy_successful
      end

      private
      def find_category
        @category = Frm::Category.find(params[:id])
      end

      def create_successful
        flash[:notice] = t("forem.admin.category.created")
        redirect_to group_frm_admin_categories_url(@group)
      end

      def create_failed
        flash.now.alert = t("forem.admin.category.not_created")
        render :action => "new"
      end

      def destroy_successful
        flash[:notice] = t("forem.admin.category.deleted")
        redirect_to group_frm_admin_categories_url(@group)
      end

      def update_successful
        flash[:notice] = t("forem.admin.category.updated")
        redirect_to group_frm_admin_categories_url(@group)
      end

      def update_failed
        flash.now.alert = t("forem.admin.category.not_updated")
        render :action => "edit"
      end

    end
  end
end
