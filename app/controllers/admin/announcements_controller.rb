module Admin
  class AnnouncementsController < Admin::ApplicationController
    load_and_authorize_resource

    def index
    end

    def show
    end

    def new
    end

    def edit
    end

    def create
      if @announcement.save
        redirect_to [:admin, @announcement], notice: 'Announcement was successfully created.'
      else
        render action: :new
      end
    end

    def update
      if @announcement.update(announcement_params)
        redirect_to [:admin, @announcement], notice: 'Announcement was successfully updated.'
      else
        render action: :edit
      end
    end

    def destroy
      @announcement.destroy
      redirect_to admin_announcements_path
    end

    protected

    def announcement_params
      params.require(:announcement).permit(:id, :message, :starts_at, :ends_at)
    end
  end
end
