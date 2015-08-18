require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe "check user permissions on proposals", type: :feature, js: true, search: true, seeds: true do

  def create_proposal_in_area(visible_outside=true)
    user = create(:user)
    group = create(:group, current_user_id: user.id)
    group.enable_areas = true
    group.save
    area = create(:group_area, group: group)
    expect(Ability.new(user)).to be_able_to(:insert_proposal, area)
    proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: visible_outside)
    return proposal
  end


  context "participants of the group" do
    let(:user) { create(:user) }
    let(:group) { create(:group, current_user_id: user.id) }

    before :each do
      @ability = Ability.new(user)

    end

    it "can't participate in group areas proposals" do
      group.enable_areas = true
      group.save
      area = create(:group_area, group: group)
      proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: true)
      participant = create(:user)
      create_participation(participant, group)
      expect(Ability.new(user)).to be_able_to(:show, proposal)
      expect(Ability.new(user)).to_not be_able_to(:participate, proposal)
    end
  end

  context "proposals in lists" do
    context "a visible_outside proposal" do
      it "is displayed in the open space list and in the group list" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)])
        visit proposals_path
        expect(page).to have_content proposal.title

        visit group_proposals_path(group)
        expect(page).to have_content proposal.title
      end

      it "is displayed in the open space list, group list and group area list" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: true)

        visit proposals_path
        expect(page).to have_content proposal.title

        visit group_proposals_path(group)
        expect(page).to have_content proposal.title

        visit group_proposals_path(group, group_area_id: area.id)
        expect(page).to have_content proposal.title
      end

      it "is not displayed in another group area list of the same group" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)
        area2 = create(:group_area, group: group)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: true)

        visit group_proposals_path(group, group_area_id: area2.id)
        expect(page).to_not have_content proposal.title
      end

      it "is not displayed in another group (group area) list" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: create(:group, current_user_id: create(:user).id))], visible_outside: true)

        visit group_proposals_path(group)
        expect(page).to_not have_content proposal.title

        visit group_proposals_path(group, group_area_id: area.id)
        expect(page).to_not have_content proposal.title
      end
    end

    context "a public proposal" do
      it "is displayed in the open space list" do
        public_proposal = create(:public_proposal, current_user_id: create(:user).id)
        visit proposals_path
        expect(page).to have_content public_proposal.title
      end

      it "is not displayed in a group list" do
        proposal = create(:public_proposal, current_user_id: create(:user).id)
        user = create(:user)
        group = create(:group, current_user_id: user.id)

        visit group_proposals_path(group)
        expect(page).to_not have_content proposal.title
      end

      it "is not displayed in a group area list" do
        proposal = create(:public_proposal, current_user_id: create(:user).id)
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)

        visit group_proposals_path(group, group_area_id: area.id)
        expect(page).to_not have_content proposal.title
      end
    end

    context "a private proposal in a group" do
      it "is not displayed in the open space list" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
        visit proposals_path
        expect(page).to_not have_content proposal.title

        login_as user, scope: :user

        visit proposals_path
        expect(page).to_not have_content proposal.title

        logout user
      end

      it "is displayed in the group list only if you are logged in" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
        visit group_proposals_path(group)
        expect(page).to_not have_content proposal.title

        login_as user, scope: :user

        visit group_proposals_path(group)
        expect(page).to have_content proposal.title

        logout user
      end

      it "is not displayed in a group area list" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

        visit group_proposals_path(group, group_area_id: area.id)
        expect(page).to_not have_content proposal.title

        login_as user, scope: :user

        visit group_proposals_path(group, group_area_id: area.id)
        expect(page).to_not have_content proposal.title

        logout user
      end
    end

    context "a private proposal in a group area" do
      it "is not displayed in the open space list" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: false)

        visit proposals_path
        expect(page).to_not have_content proposal.title

        #todo test for participants in the area
      end

      it "is displayed in the group list only if you are logged in and have the permission to see it" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: false)

        visit group_proposals_path(group)
        expect(page).to_not have_content proposal.title

        login_as user, scope: :user

        visit group_proposals_path(group)
        expect(page).to have_content proposal.title

        logout user
      end

      it "is displayed in the group list if you are logged in as group admin and have the permission to see it" do
        user = create(:user)
        participant = create(:user)
        group = create(:group, current_user_id: user.id)
        create_participation(participant, group)
        area = create(:group_area, group: group)
        create_area_participation(participant, area)
        proposal = create(:group_proposal, current_user_id: participant.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: false)

        visit group_proposals_path(group)
        expect(page).to_not have_content proposal.title

        login_as user, scope: :user

        visit group_proposals_path(group)
        expect(page).to have_content proposal.title

        logout user
      end

      it "is displayed in the group area list only if you are logged in and have the permission to see it" do
        user = create(:user)
        group = create(:group, current_user_id: user.id)
        area = create(:group_area, group: group)
        proposal = create(:group_proposal, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], group_area_id: area.id, visible_outside: false)

        visit group_proposals_path(group, group_area_id: area.id)
        expect(page).to_not have_content proposal.title

        login_as user, scope: :user

        visit group_proposals_path(group, group_area_id: area.id)
        expect(page).to have_content proposal.title

        logout user

        #todo test for participants in the area
      end
    end



  end

  context "owner of the group permissions" do

    before :each do
      @user = create(:user)
      @ability = Ability.new(@user)
      @group = create(:group, current_user_id: @user.id)
      login_as @user, scope: :user
    end

    after :each do
      logout(:user)
    end

    it "can view his public proposals" do
      @public_proposal = create(:public_proposal, current_user_id: @user.id)

      visit proposal_path(@public_proposal)
      page_should_be_ok
      expect(page).to have_content @public_proposal.title
      expect(@ability).to be_able_to(:show, @public_proposal)
    end

    it "can view other users public proposals" do
      @public_proposal = create(:public_proposal, current_user_id: create(:user).id)

      visit proposal_path(@public_proposal)
      page_should_be_ok
      expect(page).to have_content @public_proposal.title
      expect(@ability).to be_able_to(:show, @public_proposal)
    end

    it "can view private proposals in his group" do
      @proposal = create(:group_proposal, current_user_id: @user.id, group_proposals: [GroupProposal.new(group: @group)])
      visit group_proposal_path(@group, @proposal)
      page_should_be_ok
      expect(page).to have_content @group.name
      expect(page).to have_content @proposal.title
      expect(@ability).to be_able_to(:show, @proposal)
    end

    it "can view public proposals in others group" do
      @second_user = create(:user)
      @second_group = create(:group, current_user_id: @second_user.id)
      @proposal = create(:group_proposal, current_user_id: @second_user.id, group_proposals: [GroupProposal.new(group: @second_group)])
      visit group_proposal_path(@second_group, @proposal)
      expect(page.current_path).to eq(group_proposal_path(@second_group, @proposal))
      expect(@ability).to be_able_to(:show, @proposal)
    end

    it "can't view private proposals in others group" do
      @second_user = create(:user)
      @second_group = create(:group, current_user_id: @second_user.id)
      @proposal = create(:group_proposal, current_user_id: @second_user.id, group_proposals: [GroupProposal.new(group: @second_group)], visible_outside: false)
      visit group_proposal_path(@second_group, @proposal)
      expect(page).to have_content(I18n.t('error.error_302.title'))
      expect(@ability).not_to be_able_to(:show, @proposal)
    end


    it "can view public proposals in others group areas but can't participate" do
      @proposal = create_proposal_in_area
      @second_group = @proposal.groups.first
      visit group_proposal_path(@second_group, @proposal)
      expect(page.current_path).to eq(group_proposal_path(@second_group, @proposal))
      expect(@ability).to be_able_to(:show, @proposal)
      expect(@ability).not_to be_able_to(:participate, @proposal)

    end

    it "can't view private proposals in others group areas" do
      @proposal = create_proposal_in_area(false)
      @second_group = @proposal.groups.first
      visit group_proposal_path(@second_group, @proposal)
      expect(page.current_path).to eq(group_proposal_path(@second_group, @proposal))
      expect(@ability).not_to be_able_to(:show, @proposal)
      expect(@ability).not_to be_able_to(:participate, @proposal)
    end


    it "can't view private proposals in group areas in which does not participate even if he belongs to the group" do
      @proposal = create_proposal_in_area(false)
      @second_group = @proposal.groups.first
      create_participation(@user, @second_group)
      visit group_proposal_path(@second_group, @proposal)
      expect_forbidden_page
      expect(@ability).not_to be_able_to(:show, @proposal)
      expect(@ability).not_to be_able_to(:participate, @proposal)
    end
  end
end
