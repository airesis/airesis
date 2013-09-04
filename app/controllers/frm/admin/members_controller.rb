module Frm
  module Admin
    class MembersController < BaseController
      def add
        user = User.where(:id => params[:frm_user_id]).first
        unless group.members.exists?(user.id)
          group.members << user
        end
        redirect_to group_frm_admin_frm_group_url(@group, group)
      end

      private

      def group
        @frm_group ||= Frm::Group.find(params[:frm_group_id])
      end
    end
  end
end
