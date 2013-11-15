require 'test_helper'

class SysPaymentNotificationsControllerTest < ActionController::TestCase
  setup do
    @sys_payment_notification = sys_payment_notifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sys_payment_notifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sys_payment_notification" do
    assert_difference('SysPaymentNotification.count') do
      post :create, sys_payment_notification: @sys_payment_notification.attributes
    end

    assert_redirected_to sys_payment_notification_path(assigns(:sys_payment_notification))
  end

  test "should show sys_payment_notification" do
    get :show, id: @sys_payment_notification
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sys_payment_notification
    assert_response :success
  end

  test "should update sys_payment_notification" do
    put :update, id: @sys_payment_notification, sys_payment_notification: @sys_payment_notification.attributes
    assert_redirected_to sys_payment_notification_path(assigns(:sys_payment_notification))
  end

  test "should destroy sys_payment_notification" do
    assert_difference('SysPaymentNotification.count', -1) do
      delete :destroy, id: @sys_payment_notification
    end

    assert_redirected_to sys_payment_notifications_path
  end
end
