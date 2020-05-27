module Api
  module V1
    class ProposalsController < Api::V1::ApplicationController
      load_and_authorize_resource

      def index
        @proposals = @proposals.where(private: params[:private]) if params[:private]
        @proposals = @proposals.where(visible_outside: params[:visible_outside]) if params[:visible_outside]
        @proposals = @proposals.includes(:interest_borders,
                                         :groups,
                                         :users,
                                         :quorum,
                                         sections: :paragraphs, solutions: { sections: :paragraphs }).
                     page(params[:page]).per(20)
      end

      def show; end
    end
  end
end
