require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe "check user permissions on proposals", type: :feature do

  before :each do
    @user = create(:default_user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
    login_as @user, scope: :user
  end

  after :each do
    logout(:user)
  end

  it "can view his public proposals" do
    @public_proposal = create(:public_proposal, quorum: BestQuorum.public.first, current_user_id: @user.id)

    visit proposal_path(@public_proposal)
    page_should_be_ok
    expect(page).to have_content @public_proposal.title
    @ability.should be_able_to(:show, @public_proposal)
  end

  it "can view other users public proposals" do
    @public_proposal = create(:public_proposal, quorum: BestQuorum.public.first, current_user_id: create(:user).id)

    visit proposal_path(@public_proposal)
    page_should_be_ok
    expect(page).to have_content @public_proposal.title
    expect(@ability).to be_able_to(:show, @public_proposal)
  end

  it "can view private proposals in his group" do
    @proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: @user.id, group_proposals: [GroupProposal.new(group: @group)])
    visit group_proposal_path(@group, @proposal)
    page_should_be_ok
    expect(page).to have_content @group.name
    expect(page).to have_content @proposal.title
    @ability.should be_able_to(:show, @proposal)
  end

  it "can view public proposals in others group" do
    @second_user = create(:second_user)
    @second_group = create(:group, current_user_id: @second_user.id)
    @proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: @second_user.id, group_proposals: [GroupProposal.new(group: @second_group)])
    visit group_proposal_path(@second_group, @proposal)
    expect(page.current_path).to eq(group_proposal_path(@second_group,@proposal))
    @ability.should be_able_to(:show, @proposal)
  end

  it "can't view private proposals in others group" do
    @second_user = create(:second_user)
    @second_group = create(:group, current_user_id: @second_user.id)
    @proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: @second_user.id, group_proposals: [GroupProposal.new(group: @second_group)], visible_outside: false)
    visit group_proposal_path(@second_group, @proposal)
    expect(page).to have_content(I18n.t('error.error_302.title'))
    @ability.should_not be_able_to(:show, @proposal)
  end


  def create_proposal_in_area(visible_outside=true)
    user =  create(:user)
    group = create(:group, current_user_id: user.id)
    group.enable_areas = true
    group.save
    area = create(:group_area, group: group)
    expect(Ability.new(user)).to be_able_to(:insert_proposal, area)
    proposal = create(:group_proposal, quorum: BestQuorum.public.first, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: visible_outside )
    return proposal
  end

  it "can view public proposals in others group areas" do
    @proposal = create_proposal_in_area
    @second_group = @proposal.groups.first
    visit group_proposal_path(@second_group, @proposal)
    expect(page.current_path).to eq(group_proposal_path(@second_group,@proposal))
    @ability.should be_able_to(:show, @proposal)
    @ability.should_not be_able_to(:participate, @proposal)

  end

  it "can't view private proposals in others group areas" do
    @proposal = create_proposal_in_area(false)
    @second_group = @proposal.groups.first
    visit group_proposal_path(@second_group, @proposal)
    expect(page.current_path).to eq(group_proposal_path(@second_group,@proposal))
    @ability.should_not be_able_to(:show, @proposal)
    @ability.should_not be_able_to(:participate, @proposal)
  end


  it "can't view private proposals in group areas in which does not participate even if he belongs to the group" do
    @proposal = create_proposal_in_area(false)
    @second_group = @proposal.groups.first
    create_participation(@user,@second_group)
    visit group_proposal_path(@second_group, @proposal)
    expect_forbidden_page
    @ability.should_not be_able_to(:show, @proposal)
    @ability.should_not be_able_to(:participate, @proposal)
  end

end
