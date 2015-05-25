class AnnouncementsController < ApplicationController
  load_and_authorize_resource

  def hide
    ids = [params[:id], *cookies.signed[:hidden_announcement_ids]]
    cookies.permanent.signed[:hidden_announcement_ids] = ids
  end

end
