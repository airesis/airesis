require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

describe 'permissions on proposals', type: :model, js: true, search: true, seeds: true do
  context 'participants of the group' do
    let(:user) { create(:user) }
    let(:group) { create(:group, current_user_id: user.id) }

    before :each do
      @ability = Ability.new(user)
    end

    it "can't participate in group areas proposals" do
      group.enable_areas = true
      group.save
      area = create(:group_area, group: group)
      proposal = create(:group_proposal, current_user_id: user.id, groups: [group], group_area_id: area.id, visible_outside: true)
      participant = create(:user)
      create_participation(participant, group)
      expect(Ability.new(user)).to be_able_to(:show, proposal)
      expect(Ability.new(user)).to_not be_able_to(:participate, proposal)
    end
  end

  context 'group participant' do
    let(:admin) { create(:user) }
    let(:group) { create(:group, current_user_id: admin.id) }
    let(:participant) { create(:user) }
    let(:ability) { Ability.new(participant) }
    let(:area) { create(:group_area, group: group) }

    before :each do
      create_participation(participant, group)
    end

    context 'the proposal is in the group area and not visible outside' do
      let!(:proposal) do
        create(:group_proposal, current_user_id: admin.id,
                                groups: [group],
                                group_area_id: area.id, visible_outside: false)
      end
      context 'does not participate in any area' do
        context 'when is in debate' do
          it 'cant participate to the proposal' do
            expect(ability).to_not be_able_to(:participate, proposal)
          end

          it 'cant see the proposal' do
            expect(ability).to_not be_able_to(:show, proposal)
          end
        end
        context 'when is voting' do
          before :each do
            proposal.update_columns(proposal_state_id: ProposalState::VOTING)
          end
          it 'cant participate' do
            expect(ability).to_not be_able_to(:participate, proposal)
          end
          it 'cant see' do
            expect(ability).to_not be_able_to(:show, proposal)
          end
          it 'cant vote' do
            expect(ability).to_not be_able_to(:vote, proposal)
          end
        end
      end
    end

    context 'the proposal is in the group area and visible outside' do
      let!(:proposal) do
        create(:group_proposal, current_user_id: admin.id,
                                groups: [group],
                                group_area_id: area.id, visible_outside: true)
      end
      context 'does not participate in any area' do
        context 'when is in debate' do
          it 'cant participate to the proposal' do
            expect(ability).to_not be_able_to(:participate, proposal)
          end

          it 'can see the proposal' do
            expect(ability).to be_able_to(:show, proposal)
          end
        end
        context 'when is voting' do
          before :each do
            proposal.update_columns(proposal_state_id: ProposalState::VOTING)
          end
          it 'cant participate' do
            expect(ability).to_not be_able_to(:participate, proposal)
          end
          it 'can see' do
            expect(ability).to be_able_to(:show, proposal)
          end
          it 'cant vote' do
            expect(ability).to_not be_able_to(:vote, proposal)
          end
        end
      end
    end
  end

  context 'owner of the group permissions' do
    before :each do
      @user = create(:user)
      @ability = Ability.new(@user)
      @group = create(:group, current_user_id: @user.id)
    end

    it 'can view his public proposals' do
      @public_proposal = create(:public_proposal, current_user_id: @user.id)
      expect(@ability).to be_able_to(:show, @public_proposal)
    end

    it 'can view other users public proposals' do
      @public_proposal = create(:public_proposal, current_user_id: create(:user).id)
      expect(@ability).to be_able_to(:show, @public_proposal)
    end

    it 'can view private proposals in his group' do
      @proposal = create(:group_proposal, current_user_id: @user.id, groups: [@group])
      expect(@ability).to be_able_to(:show, @proposal)
    end

    it 'can view public proposals in others group' do
      @second_user = create(:user)
      @second_group = create(:group, current_user_id: @second_user.id)
      @proposal = create(:group_proposal, current_user_id: @second_user.id, groups: [@second_group])
      expect(@ability).to be_able_to(:show, @proposal)
    end

    it "can't view private proposals in others group" do
      @second_user = create(:user)
      @second_group = create(:group, current_user_id: @second_user.id)
      @proposal = create(:group_proposal, current_user_id: @second_user.id, groups: [@second_group], visible_outside: false)
      expect(@ability).not_to be_able_to(:show, @proposal)
    end

    it "can view public proposals in others group areas but can't participate" do
      @proposal = create_proposal_in_area
      @second_group = @proposal.groups.first
      expect(@ability).to be_able_to(:show, @proposal)
      expect(@ability).not_to be_able_to(:participate, @proposal)
    end

    it "can't view private proposals in others group areas" do
      @proposal = create_proposal_in_area(false)
      @second_group = @proposal.groups.first
      expect(@ability).not_to be_able_to(:show, @proposal)
      expect(@ability).not_to be_able_to(:participate, @proposal)
    end

    it "can't view private proposals in group areas in which does not participate even if he belongs to the group" do
      proposal = create_proposal_in_area(false)
      second_group = proposal.groups.first
      create_participation(@user, second_group)
      expect(@ability).not_to be_able_to(:show, proposal)
      expect(@ability).not_to be_able_to(:participate, proposal)
    end
  end

  context 'group admin permissions' do
    let(:admin) { create(:user) }
    let(:group) { create(:group, current_user_id: admin.id) }
    let(:participant) { create(:user) }
    let(:ability) { Ability.new(admin) }
    let(:area) { create(:group_area, group: group) }
    let!(:proposal) do
      create(:group_proposal, current_user_id: participant.id,
                              groups: [group])
    end
    before :each do
      create_participation(participant, group)
    end

    context 'on his group' do
      let!(:proposal) do
        create(:group_proposal, current_user_id: participant.id,
                                groups: [group]).reload
      end

      it 'can delete proposals' do
        expect(ability).to be_able_to(:destroy, proposal)
      end

      it 'can close the debate of proposals at any time' do
        expect(ability).to be_able_to(:close_debate, proposal)
      end
      it 'can start the votation of proposals at any time' do
        proposal.update_attributes(proposal_state_id: ProposalState::WAIT)
        expect(ability).to be_able_to(:start_votation, proposal)
      end
    end

    context 'in other groups' do
      let!(:proposal) do
        create(:group_proposal, current_user_id: participant.id,
                                groups: [create(:group)])
      end

      it 'cannot delete proposals' do
        expect(ability).not_to be_able_to(:destroy, proposal)
      end

      it 'cannot close the debate of proposals at any time' do
        expect(ability).not_to be_able_to(:close_debate, proposal)
      end
      it 'cannot start the votation of proposals at any time' do
        expect(ability).not_to be_able_to(:start_votation, proposal)
      end
    end
  end
end
