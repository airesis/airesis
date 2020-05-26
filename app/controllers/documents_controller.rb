class DocumentsController < ApplicationController
  layout 'groups'

  before_action :load_group, except: [:view]
  before_action :authenticate_user!

  def index
    authorize! :view_data, @group
    authorize! :view_documents, @group
  end

  def view
    url = params[:url]
    group_id = params[:url][%r{/private/elfinder/([^/]*)/(.*)}, 1]
    @group = Group.find(group_id)

    authorize! :view_documents, @group

    url = Rails.root.join(params[:url][1..])
    if params[:download]
      send_file url
    else
      send_file url, disposition: 'inline'
    end
  end
end
