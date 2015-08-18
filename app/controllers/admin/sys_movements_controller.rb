module Admin
  class SysMovementsController < Admin::ApplicationController

    def index
      @sys_movements = SysMovement.all
    end

    def show
      @sys_movement = SysMovement.find(params[:id])
    end

    def new
      @sys_movement = SysMovement.new
    end

    def edit
      @sys_movement = SysMovement.find(params[:id])
    end

    def create
      @sys_movement = SysMovement.new(sys_movement_params)
      @sys_movement.user_id = current_user.id
      if @sys_movement.save
        redirect_to [:admin, @sys_movement], notice: 'Sys movement was successfully created.'
      else
        render action: :new
      end
    end

    def update
      @sys_movement = SysMovement.find(params[:id])

      if @sys_movement.update(sys_movement_params)
        redirect_to [:admin, @sys_movement], notice: 'Sys movement was successfully updated.'
      else
        render action: :edit
      end
    end

    def destroy
      @sys_movement = SysMovement.find(params[:id])
      @sys_movement.destroy

      redirect_to admin_sys_movements_path
    end

    protected

    def sys_movement_params
      params.require(:sys_movement).permit(:sys_currency_id, :sys_movement_type_id, :amount, :description, :made_on)
    end
  end
end
