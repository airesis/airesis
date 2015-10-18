module Api
  module V1
    class ApplicationController < ActionController::Base
      acts_as_token_authentication_handler_for User, fallback: :none

      protect_from_forgery with: :null_session
      respond_to :json
    end
  end
end
