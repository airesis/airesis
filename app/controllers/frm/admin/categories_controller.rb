module Frm
  module Admin
    class CategoriesController < BaseController

      before_filter :find_category, only: [:edit, :update, :destroy]

      def index
        @categories = @group.categories.all
      end

      def new
        @category = @group.categories.build
      end

      def create
        @category = @group.categories.build(params[:frm_category])
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
        @category = @group.categories.friendly.find(params[:id])
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
        render action: "new"
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
        respond_to do |format|
          format.html {
            render action: "edit"
          }
          format.js {
            render :update do |page|
              page.replace_html 'category_container', partial: 'edit', locals: {remote: true}
            end
          }
        end

      end

    end
  end
end
