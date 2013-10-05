require 'test_helper'

class UserLikesControllerTest < ActionController::TestCase
  setup do
    @user_like = user_likes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_likes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_like" do
    assert_difference('UserLike.count') do
      post :create, user_like: @user_like.attributes
    end

    assert_redirected_to user_like_path(assigns(:user_like))
  end

  test "should show user_like" do
    get :show, id: @user_like
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_like
    assert_response :success
  end

  test "should update user_like" do
    put :update, id: @user_like, user_like: @user_like.attributes
    assert_redirected_to user_like_path(assigns(:user_like))
  end

  test "should destroy user_like" do
    assert_difference('UserLike.count', -1) do
      delete :destroy, id: @user_like
    end

    assert_redirected_to user_likes_path
  end
end
