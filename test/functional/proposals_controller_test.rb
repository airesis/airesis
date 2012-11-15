require 'test_helper'

class ActionController::TestCase
  include Devise::TestHelpers  
end

class ProposalsControllerTest < ActionController::TestCase
  
  test "get_index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proposals)
  end
end
