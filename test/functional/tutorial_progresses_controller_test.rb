require 'test_helper'

class TutorialProgressesControllerTest < ActionController::TestCase
  setup do
    @tutorial_progress = tutorial_progresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tutorial_progresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tutorial_progress" do
    assert_difference('TutorialProgress.count') do
      post :create, tutorial_progress: @tutorial_progress.attributes
    end

    assert_redirected_to tutorial_progress_path(assigns(:tutorial_progress))
  end

  test "should show tutorial_progress" do
    get :show, id: @tutorial_progress.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tutorial_progress.to_param
    assert_response :success
  end

  test "should update tutorial_progress" do
    put :update, id: @tutorial_progress.to_param, tutorial_progress: @tutorial_progress.attributes
    assert_redirected_to tutorial_progress_path(assigns(:tutorial_progress))
  end

  test "should destroy tutorial_progress" do
    assert_difference('TutorialProgress.count', -1) do
      delete :destroy, id: @tutorial_progress.to_param
    end

    assert_redirected_to tutorial_progresses_path
  end
end
