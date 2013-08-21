#encoding: utf-8
class DocumentsController < ApplicationController

  layout 'groups'

  before_filter :load_group, :except => [:view]


  before_filter :authenticate_user!

  def index
    authorize! :view_data, @group
  end

  def view
    url = params[:url]
    group_id = params[:url][/\/private\/elfinder\/([^\/]*)\/(.*)/,1]
    @group = Group.find(group_id)

    authorize! :view_documents, @group

    url = Rails.root.join(params[:url][1..-1])
    if params[:download]
      send_file url
    else
      send_file url, :disposition => 'inline'
    end

  end

  protected

  def load_group
    @group = params[:group_id] ? Group.find(params[:group_id]) : Group.find_by_subdomain(request.subdomain)
  end
end
