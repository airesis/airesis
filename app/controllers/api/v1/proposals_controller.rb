module Api
  module V1
    class ProposalsController < Api::V1::ApplicationController
      load_and_authorize_resource

      def index
      end
    end
  end
end
