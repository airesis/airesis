require 'spec_helper'

describe Api::V1::ProposalsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/proposals').to route_to('api/v1/proposals#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/proposals/1').to route_to(controller: 'api/v1/proposals', action: 'show', id: '1')
    end
  end
end
