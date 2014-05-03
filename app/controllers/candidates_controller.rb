#encoding: utf-8
class CandidatesController < ApplicationController
  include StepHelper
  
  layout "groups"

  before_filter :authenticate_user!
  before_filter :admin_required

  def index
    @step = get_next_step(current_user)
    @group = params[:group_id] ? Group.find(params[:group_id]) : request.subdomain ? Group.find_by_subdomain(request.subdomain) : nil
    raise CanCan::AccessDenied if @group.certified?
    authorize! :view_data, @group
    @page_title = @group.name + ": Area candidature"
  end
  
  def show
    
  end
end
