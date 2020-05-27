module Validators
  class UniquenessController < ApplicationController
    respond_to :json

    def group
      validate_uniqueness(:group, :name)
    end

    def user
      validate_uniqueness(:user, :email)
    end

    def proposal
      validate_uniqueness(:proposal, :title)
    end

    protected

    def validate_uniqueness(model, attribute)
      fparams = params.require(model).permit(attribute, :id)
      already_exists = model.to_s.classify.constantize.where(attribute => fparams[attribute].strip)
      already_exists = already_exists.where.not(id: fparams[:id]) if fparams[:id].present?
      render json: { valid: !already_exists.exists? }
    end
  end
end
