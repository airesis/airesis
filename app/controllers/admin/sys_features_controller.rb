module Admin
  class SysFeaturesController < Admin::ApplicationController

    def index
      @sys_features = SysFeature.all
    end

    def show
      @sys_feature = SysFeature.find(params[:id])
    end

    def new
      @sys_feature = SysFeature.new
    end

    def edit
      @sys_feature = SysFeature.find(params[:id])
    end

    def create
      @sys_feature = SysFeature.new(sys_feature_params)

      if @sys_feature.save
        redirect_to [:admin, @sys_feature], notice: 'Sys feature was successfully created.'
      else
        render action: :new
      end
    end

    def update
      @sys_feature = SysFeature.find(params[:id])

      if @sys_feature.update(sys_feature_params)
        redirect_to [:admin, @sys_feature], notice: 'Sys feature was successfully updated.'
      else
        render action: :edit
      end
    end

    def destroy
      @sys_feature = SysFeature.find(params[:id])
      @sys_feature.destroy

      redirect_to admin_sys_features_path
    end

    protected

    def sys_feature_params
      params.require(:sys_feature).permit(:title, :description, :amount_required, :amount_received)
    end
  end
end
