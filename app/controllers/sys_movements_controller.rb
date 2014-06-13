#encoding: utf-8
class SysMovementsController < ApplicationController

  layout 'open_space'

  before_filter :moderator_required

  def index
    @sys_movements = SysMovement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sys_movements }
    end
  end

  def show
    @sys_movement = SysMovement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sys_movement }
    end
  end

  def new
    @sys_movement = SysMovement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sys_movement }
    end
  end

  def edit
    @sys_movement = SysMovement.find(params[:id])
  end

  def create
    @sys_movement = SysMovement.new(params[:sys_movement])
    @sys_movement.user_id = current_user.id
    respond_to do |format|
      if @sys_movement.save
        format.html { redirect_to @sys_movement, notice: 'Sys movement was successfully created.' }
        format.json { render json: @sys_movement, status: :created, location: @sys_movement }
      else
        format.html { render action: "new" }
        format.json { render json: @sys_movement.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @sys_movement = SysMovement.find(params[:id])

    respond_to do |format|
      if @sys_movement.update_attributes(params[:sys_movement])
        format.html { redirect_to @sys_movement, notice: 'Sys movement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sys_movement.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @sys_movement = SysMovement.find(params[:id])
    @sys_movement.destroy

    respond_to do |format|
      format.html { redirect_to sys_movements_url }
      format.json { head :no_content }
    end
  end

  protected

  def sys_movement_params
    params.require(:sys_movement).permit(:sys_currency_id, :sys_movement_type_id, :amount, :made_on, :description)
  end
end
