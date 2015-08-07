module Validators
  class UniquenessController < ApplicationController
    respond_to :json

    def group
      already_exists = Group.where(name: params.require(:group).require(:name).strip).exists?
      render json: {valid: !already_exists}
    end

    def user
      already_exists = User.where(email: params.require(:user).require(:email).strip).exists?
      render json: {valid: !already_exists}
    end

    def proposal
      already_exists = Proposal.where(title: params.require(:proposal).require(:title).strip).exists?
      render json: {valid: !already_exists}
    end
  end
end
