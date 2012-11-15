require 'test_helper'

class TutorialAssigneesControllerTest < ActionController::TestCase
  setup do
    @tutorial_assignee = tutorial_assignees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tutorial_assignees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tutorial_assignee" do
    assert_difference('TutorialAssignee.count') do
      post :create, tutorial_assignee: @tutorial_assignee.attributes
    end

    assert_redirected_to tutorial_assignee_path(assigns(:tutorial_assignee))
  end

  test "should show tutorial_assignee" do
    get :show, id: @tutorial_assignee.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tutorial_assignee.to_param
    assert_response :success
  end

  test "should update tutorial_assignee" do
    put :update, id: @tutorial_assignee.to_param, tutorial_assignee: @tutorial_assignee.attributes
    assert_redirected_to tutorial_assignee_path(assigns(:tutorial_assignee))
  end

  test "should destroy tutorial_assignee" do
    assert_difference('TutorialAssignee.count', -1) do
      delete :destroy, id: @tutorial_assignee.to_param
    end

    assert_redirected_to tutorial_assignees_path
  end
end
