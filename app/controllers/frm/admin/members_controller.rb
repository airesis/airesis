module Frm
  module Admin
    class MembersController < BaseController
      def add
        user = User.where(id: params[:frm_user_id]).first
        unless group.members.exists?(user.id)
          flash[:notice] = t('info.members.ok_message')
          group.members << user
        end
        respond_to do |format|
          format.html {
            redirect_to group_frm_admin_mod_url(@group, group)
          }
          format.js
        end
      end

      private

      def group
        @frm_mod ||= Frm::Mod.find(params[:mod_id])
      end
    end
  end
end
