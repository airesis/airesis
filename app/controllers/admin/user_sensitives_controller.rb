module Admin
  class UserSensitivesController < Admin::ApplicationController

    layout 'open_space'

    before_filter :moderator_required

    def index
      @user_sensitives = UserSensitive.all
    end

    def show
      @user_sensitive = UserSensitive.find(params[:id])
    end


    def new
      @user_sensitive = UserSensitive.new
    end


    def edit
      @user_sensitive = UserSensitive.find(params[:id])
    end


    def create
      @user_sensitive = UserSensitive.new(params[:user_sensitive])

        if @user_sensitive.save
          redirect_to @user_sensitive, notice: 'User sensitive was successfully created.'
        else
          render action: "new" 
        end
    end


    def update
      @user_sensitive = UserSensitive.find(params[:id])

      respond_to do |format|
        if @user_sensitive.update_attributes(params[:user_sensitive])
          format.html { redirect_to @user_sensitive, notice: 'User sensitive was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end


    def destroy
      @user_sensitive = UserSensitive.find(params[:id])
      @user_sensitive.destroy

      respond_to do |format|
        format.html { redirect_to user_sensitives_url }
      end
    end

    def document
      @user_sensitive = UserSensitive.find(params[:id])

      send_file @user_sensitive.document.url(:default, timestamp: false)
    end
  end
end
