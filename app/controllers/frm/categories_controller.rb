module Frm
  class CategoriesController < Frm::ApplicationController
    helper 'frm/forums'
    #load_and_authorize_resource class: 'Frm::Category'

    before_filter :load_category

    def show
      authorize! :read, @category
    end


    protected

    def load_category
      @category = @group.categories.friendly.find(params[:id])
    end
  end
end
