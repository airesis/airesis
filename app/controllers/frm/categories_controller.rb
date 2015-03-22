module Frm
  class CategoriesController < Frm::ApplicationController
    helper 'frm/forums'

    load_and_authorize_resource class: 'Frm::Category', through: :group

    def show
    end

    protected

    def category_params
      params.require(:category).permit(:name, :visible_outside, :tags_list)
    end
  end
end
