module Admin
  class SysLocalesController < Admin::ApplicationController
    load_and_authorize_resource

    def index
      @sys_locales = @sys_locales.order(:key)
    end

    def new
    end

    def create
      if @sys_locale.save
        redirect_to admin_sys_locales_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @sys_locale.update(sys_locale_params)
        redirect_to admin_sys_locales_path
      else
        render :edit
      end
    end

    protected

    def sys_locale_params
      params.require(:sys_locale).permit(:key, :host, :lang, :territory_type, :territory_id, :default)
    end
  end
end
