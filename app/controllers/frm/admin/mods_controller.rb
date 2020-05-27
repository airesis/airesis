module Frm
  module Admin
    class ModsController < BaseController
      before_action :load_frm_mod, only: %i[show destroy]
      authorize_resource class: 'Frm::Mod'

      def index
        @page_title = t('frm.admin.group.index')
        @frm_mods = @group.mods
      end

      def show
        @page_title = t('frm.admin.group.show.title')
      end

      def new
        @page_title = t('frm.admin.group.new')
        @frm_mod = @group.mods.build
      end

      def create
        @frm_mods = @group.mods
        @frm_mod = @frm_mods.build(mod_params)
        if @frm_mod.save
          flash[:notice] = t('frm.admin.group.created')
          respond_to do |format|
            format.html do
              redirect_to group_frm_admin_frm_mod_url(@group, @frm_mod)
            end
            format.js
          end
        else
          flash[:alert] = t('frm.admin.group.not_created')
          render :new
        end
      end

      def destroy
        @frm_mod.destroy
        flash[:notice] = t('frm.admin.group.deleted')
        redirect_to group_frm_admin_mods_url(@group)
      end

      protected

      def mod_params
        params.require(:frm_mod).permit(:name)
      end

      private

      def load_frm_mod
        @frm_mod = @group.mods.find(params[:id])
      end
    end
  end
end
