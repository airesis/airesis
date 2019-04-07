require 'rails_helper'
require 'cancan/matchers'

RSpec.describe 'api/v1/proposals#index', type: :request, seeds: true do
  let!(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let!(:proposals) do
    create_list(:public_proposal, 2)
    create_list(:group_proposal, 2,
                quorum: group.quorums.active.first,
                current_user_id: user.id,
                visible_outside: true,
                groups: [group])
    create_list(:group_proposal, 2,
                quorum: group.quorums.active.first,
                current_user_id: user.id,
                visible_outside: false,
                groups: [group])
  end

  def send_request(headers = {})
    get api_v1_proposals_path, headers: headers
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end

  context 'without authentication' do
    before do
      send_request
    end

    it 'retrieves only public proposals' do
      expect(json_response[:proposals].size).to eq 4
    end
  end

  context 'with authentication' do
    before do
      headers = { 'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token }
      send_request(headers)
    end

    it 'retrieves public proposals and his proposals' do
      Proposal.all.each do |p|
      end
      expect(json_response[:proposals].size).to eq 6
    end
  end
end
