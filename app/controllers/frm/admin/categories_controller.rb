module Frm
  module Admin
    class CategoriesController < BaseController

      before_filter :find_category, :only => [:edit, :update, :destroy]

      def index
        @categories = Frm::Category.all
      end

      def new
        @category = Frm::Category.new
      end

      def create
        @category = Frm::Category.new(params[:frm_category])
        @category.group_id = @group.id
        if @category.save
          @categories = @group.categories
          create_successful
        else
          create_failed
        end
      end

      def update
        if @category.update_attributes(params[:frm_category])
          @categories = @group.categories
          update_successful
        else
          update_failed
        end
      end

      def destroy
        @category.destroy
        @categories = @group.categories
        destroy_successful
      end

      private
      def find_category
        @category = Frm::Category.find(params[:id])
      end

      def create_successful
        flash[:notice] = t("frm.admin.category.created")
        respond_to do |format|
          format.html {
            redirect_to group_frm_admin_categories_url(@group)
          }
          format.js
        end

      end

      def create_failed
        flash.now.alert = t("frm.admin.category.not_created")
        render :action => "new"
      end

      def destroy_successful
        flash[:notice] = t("frm.admin.category.deleted")
        respond_to do |format|
          format.html {
            redirect_to group_frm_admin_categories_url(@group)
          }
          format.js
        end
      end

      def update_successful
        flash[:notice] = t("frm.admin.category.updated")
        respond_to do |format|
          format.html {
            redirect_to group_frm_admin_categories_url(@group)
          }
          format.js
        end

      end

      def update_failed
        flash.now.alert = t("frm.admin.category.not_updated")
        render :action => "edit"
      end

    end
  end
end
