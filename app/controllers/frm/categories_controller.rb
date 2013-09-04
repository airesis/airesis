module Frm
  class CategoriesController < Frm::ApplicationController
    helper 'frm/forums'
    load_and_authorize_resource :class => 'Frm::Category'
  end
end
