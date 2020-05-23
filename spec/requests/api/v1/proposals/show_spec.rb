require 'rails_helper'
require 'cancan/matchers'

RSpec.describe 'api/v1/proposals#show', type: :request, seeds: true do
  let!(:user) { create(:user) }
  let!(:public_proposal) { create(:public_proposal) }

  def send_request(headers = {})
    get api_v1_proposal_path(public_proposal), headers: headers
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end

  context 'without authentication' do
    before do
      send_request
    end

    it 'retrieves the proposal' do
      expect(json_response[:proposal][:id]).to eq public_proposal.id
    end
  end
end
