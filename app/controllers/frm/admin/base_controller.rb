module Frm
  module Admin
    class BaseController < ApplicationController

      layout 'groups'

      before_filter :load_group
      before_filter :authorize_frm_admin



      def index

      end

      protected

      def authorize_frm_admin
        authorize! :update, @group
      end
    end
  end
end
