#encoding: utf-8
class AnnouncementsController < ApplicationController

  layout 'open_space'

  before_filter :moderator_required, except: :hide

  def index
    @announcements = Announcement.all
    respond_to do |format|
      format.html
      format.json { render json: @announcements }
    end
  end

  def show
    @announcement = Announcement.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @announcement }
    end
  end

  def new
    @announcement = Announcement.new
    respond_to do |format|
      format.html
      format.json { render json: @announcement }
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def create
    @announcement = Announcement.new(params[:announcement])

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
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        format.html { redirect_to @announcement, notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
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
end
