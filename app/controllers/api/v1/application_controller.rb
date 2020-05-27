module Api
  module V1
    class ApplicationController < ActionController::Base
      acts_as_token_authentication_handler_for User, fallback: :none

      protect_from_forgery with: :null_session
      respond_to :json

      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from CanCan::AccessDenied, with: :render_401

      protected

      def render_401
        render json: { error_key: :unauthorized }, status: :unauthorized
      end

      def render_404
        render json: { error_key: :not_found }, status: :not_found
      end
    end
  end
end
