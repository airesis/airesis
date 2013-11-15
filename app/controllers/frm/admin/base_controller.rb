module Frm
  module Admin
    class BaseController < ApplicationController

      layout 'groups'

      before_filter :load_group


      def index
        authorize! :update, @group
      end

    end
  end
end
