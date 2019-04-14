module Frm
  module Admin
    class BaseController < ApplicationController
      layout 'groups'

      before_action :authorize_frm_admin

      def index
      end

      protected

      def authorize_frm_admin
        load_group
        authorize! :update, @group
      end
    end
  end
end
