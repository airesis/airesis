require 'test_helper'

class SysMovementsControllerTest < ActionController::TestCase
  setup do
    @sys_movement = sys_movements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sys_movements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sys_movement" do
    assert_difference('SysMovement.count') do
      post :create, sys_movement: @sys_movement.attributes
    end

    assert_redirected_to sys_movement_path(assigns(:sys_movement))
  end

  test "should show sys_movement" do
    get :show, id: @sys_movement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sys_movement
    assert_response :success
  end

  test "should update sys_movement" do
    put :update, id: @sys_movement, sys_movement: @sys_movement.attributes
    assert_redirected_to sys_movement_path(assigns(:sys_movement))
  end

  test "should destroy sys_movement" do
    assert_difference('SysMovement.count', -1) do
      delete :destroy, id: @sys_movement
    end

    assert_redirected_to sys_movements_path
  end
end
