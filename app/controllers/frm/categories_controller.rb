module Frm
  class CategoriesController < Frm::ApplicationController
    helper 'frm/forums'

    before_filter :load_group
    authorize_resource :group
    load_and_authorize_resource class: 'Frm::Category', through: :group, find_by: :slug

    def show
    end

    protected

    def category_params
      params.require(:category).permit(:name, :visible_outside, :tags_list)
    end
  end
end
