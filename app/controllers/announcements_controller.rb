#encoding: utf-8
class AnnouncementsController < ApplicationController

  layout 'open_space'

  before_filter :moderator_required, except: [:hide, :index,:show]

  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: @announcements }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @announcement }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render json: @announcement }
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if @announcement.save
        format.html { redirect_to @announcement, notice: 'Announcement was successfully created.' }
        format.json { render json: @announcement, status: :created, location: @announcement }
      else
        format.html { render action: "new" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @announcement.update_attributes(announcement_params)
        format.html { redirect_to @announcement, notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to announcements_url }
      format.json { head :no_content }
    end
  end

  def hide
    ids = [params[:id], *cookies.signed[:hidden_announcement_ids]]
    cookies.permanent.signed[:hidden_announcement_ids] = ids
  end



  protected

  def announcement_params
      params.require(:announcement).permit(:id, :message, :starts_at, :ends_at)
  end
end
