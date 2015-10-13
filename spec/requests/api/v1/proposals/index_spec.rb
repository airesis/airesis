require 'spec_helper'

describe 'api/v1/proposals#index', type: :request do
  def send_request
    get api_v1_proposals_path
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end

  context 'without authentication' do
    let(:user) { create(:user) }
    let(:group) { create(:group, current_user_id: user.id) }

    before(:each) do
      create(:best_quorum)
      create(:province)
      create_list(:public_proposal, 2)
      create_list(:group_proposal, 2,
                  quorum: group.quorums.active.first,
                  current_user_id: user.id,
                  visible_outside: false,
                  group_proposals: [GroupProposal.new(group: group)])
      create_list(:group_proposal, 2,
                  quorum: group.quorums.active.first,
                  current_user_id: user.id,
                  group_proposals: [GroupProposal.new(group: group)])
      send_request
    end

    it 'retrieves only public proposals' do
      expect(json_response[:proposals].size).to eq 4
    end
  end
end
