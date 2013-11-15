require 'test_helper'

class SysFeaturesControllerTest < ActionController::TestCase
  setup do
    @sys_feature = sys_features(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sys_features)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sys_feature" do
    assert_difference('SysFeature.count') do
      post :create, sys_feature: @sys_feature.attributes
    end

    assert_redirected_to sys_feature_path(assigns(:sys_feature))
  end

  test "should show sys_feature" do
    get :show, id: @sys_feature
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sys_feature
    assert_response :success
  end

  test "should update sys_feature" do
    put :update, id: @sys_feature, sys_feature: @sys_feature.attributes
    assert_redirected_to sys_feature_path(assigns(:sys_feature))
  end

  test "should destroy sys_feature" do
    assert_difference('SysFeature.count', -1) do
      delete :destroy, id: @sys_feature
    end

    assert_redirected_to sys_features_path
  end
end
