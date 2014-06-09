require 'spec_helper'
require 'requests_helper'

describe "check user permissions on proposals" do
  before :all do
    @user = create(:default_user)
    login_as @user, scope: :user
    @group = create(:default_group, current_user_id: @user.id)
  end

  after :all do
    logout(:user)
  end

  it "can view public proposals" do
    @public_propsoal = create(:public_proposal)

    visit proposal_path(@public_proposal)
    page_should_be_ok
  end

  it "can view private proposals in his group" do
    @proposal = create(:group_proposal, group_id: @group.id)

    visit proposal_path(@public_proposal)
    page_should_be_ok
  end
end