module Frm
  module Admin
    class CategoriesController < BaseController

      load_and_authorize_resource class: 'Frm::Category', through: :group

      def index
      end

      def new
      end

      def create
        if @category.save
          @categories = @group.categories
          create_successful
        else
          create_failed
        end
      end

      def update
        if @category.update(category_params)
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

      protected

      def category_params
        params.require(:frm_category).permit(:name, :visible_outside, :tags_list)
      end

      private

      def create_successful
        flash[:notice] = t('frm.admin.category.created')
        respond_to do |format|
          format.html {
            redirect_to group_frm_admin_categories_url(@group)
          }
          format.js
        end
      end

      def create_failed
        flash.now.alert = t('frm.admin.category.not_created')
        render action: :new
      end

      def destroy_successful
        flash[:notice] = t('frm.admin.category.deleted')
        respond_to do |format|
          format.html {
            redirect_to group_frm_admin_categories_url(@group)
          }
          format.js
        end
      end

      def update_successful
        flash[:notice] = t('frm.admin.category.updated')
        respond_to do |format|
          format.html {
            redirect_to group_frm_admin_categories_url(@group)
          }
          format.js
        end
      end

      def update_failed
        flash.now.alert = t('frm.admin.category.not_updated')
        respond_to do |format|
          format.html {
            render action: :edit
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
