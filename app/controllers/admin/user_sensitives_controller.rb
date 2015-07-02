module Admin
  class UserSensitivesController < Admin::ApplicationController
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
      @user_sensitive = UserSensitive.new(user_sensitive_params)

      if @user_sensitive.save
        redirect_to [:admin, @user_sensitive], notice: t('info.user_sensitive.created')
      else
        render action: :new
      end
    end

    def update
      @user_sensitive = UserSensitive.find(params[:id])

      if @user_sensitive.update(user_sensitive_params)
        redirect_to [:admin, @user_sensitive], notice: t('info.user_sensitive.updated')
      else
        render action: :edit
      end
    end

    def destroy
      @user_sensitive = UserSensitive.find(params[:id])
      @user_sensitive.destroy

      redirect_to admin_user_sensitives_url
    end

    def document
      @user_sensitive = UserSensitive.find(params[:id])
      send_file @user_sensitive.document.url(:default, timestamp: false)
    end

    protected

    def user_sensitive_params
      params.require(:user_sensitive).permit(:user_id, :name, :surname, :birth_date, :tax_code, :document)
    end
  end
end
