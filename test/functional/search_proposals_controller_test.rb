require 'test_helper'

class SearchProposalsControllerTest < ActionController::TestCase
  setup do
    @search_proposal = search_proposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_proposals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_proposal" do
    assert_difference('SearchProposal.count') do
      post :create, search_proposal: @search_proposal.attributes
    end

    assert_redirected_to search_proposal_path(assigns(:search_proposal))
  end

  test "should show search_proposal" do
    get :show, id: @search_proposal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_proposal
    assert_response :success
  end

  test "should update search_proposal" do
    put :update, id: @search_proposal, search_proposal: @search_proposal.attributes
    assert_redirected_to search_proposal_path(assigns(:search_proposal))
  end

  test "should destroy search_proposal" do
    assert_difference('SearchProposal.count', -1) do
      delete :destroy, id: @search_proposal
    end

    assert_redirected_to search_proposals_path
  end
end
