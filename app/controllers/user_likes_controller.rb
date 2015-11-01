class UserLikesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user_like = UserLike.new(user_like_params)
    @user_like.user_id = current_user.id
    respond_to do |format|
      if @user_like.save
        format.js { render nothing: true, status: 200 }
      else
        format.js { render nothing: true, status: 500 }
      end
    end
  end

  def destroy
    @user_like = UserLike.find_by(likeable_id: params[:user_like][:likeable_id], likeable_type: params[:user_like][:likeable_type])
    @user_like.destroy

    respond_to do |format|
      format.js { render nothing: true, status: 200 }
    end
  end

  protected

  def user_like_params
    params.require(:user_like).permit(:likeable_id, :likeable_type)
  end
end
