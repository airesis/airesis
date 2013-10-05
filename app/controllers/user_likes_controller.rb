class UserLikesController < ApplicationController


  before_filter :authenticate_user!

  #def index
  #  @user_likes = UserLike.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @user_likes }
  #  end
  #end


  #def show
  #  @user_like = UserLike.find(params[:id])

  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @user_like }
  #  end
  #end


  #def new
  #  @user_like = UserLike.new

  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @user_like }
  #  end
  #end


  #def edit
  #  @user_like = UserLike.find(params[:id])
  #end


  def create

    @user_like = UserLike.new(params[:user_like])
    @user_like.user_id = current_user.id
    respond_to do |format|
      if @user_like.save
        format.js {render nothing: true, status: 200}
      else
        format.js {render nothing: true, status: 500}
      end
    end
  end


  #def update
  #  @user_like = UserLike.find(params[:id])

  #  respond_to do |format|
  #    if @user_like.update_attributes(params[:user_like])
  #      format.html { redirect_to @user_like, notice: 'User like was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @user_like.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end


  def destroy
    @user_like = UserLike.find_by_likeable_id_and_likeable_type(params[:user_like][:likeable_id],params[:user_like][:likeable_type])
    @user_like.destroy

    respond_to do |format|
      format.js {render nothing: true, status: 200}
    end
  end
end
