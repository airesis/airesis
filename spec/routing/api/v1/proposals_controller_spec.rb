require 'spec_helper'

describe Api::V1::ProposalsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/proposals').to route_to('api/v1/proposals#index')
    end
  end
end
