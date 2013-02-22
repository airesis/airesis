#encoding: utf-8
class DocumentsController < ApplicationController

  layout 'groups'

  before_filter :load_group, :except => [:view]


  before_filter :authenticate_user!


  def view

    url = params[:url]
    group_id = params[:url][/\/private\/elfinder\/([^\/]*)\/(.*)/,1]
    @group = Group.find(group_id)


    url = Rails.root.join(params[:url][1..-1])
    if params[:download]
      authorize! :download_documents, @group
      send_file url
    else
      authorize! :view_documents, @group
      send_file url, :disposition => 'inline'
    end

  end

  protected

  def load_group
    @group = Group.find(params[:group_id])
  end
end
