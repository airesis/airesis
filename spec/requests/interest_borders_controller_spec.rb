require 'rails_helper'

RSpec.describe InterestBordersController do
  describe 'GET index' do
    it 'retrieves continents correctly' do
      get interest_borders_path, params: { q: 'Eur', format: :json }
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves countries correctly' do
      get interest_borders_path, params: { q: 'Ita', format: :json }
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves regions correctly' do
      get interest_borders_path, params: { q: 'emi', format: :json }
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves provinces correctly' do
      region = Region.find_by(description: 'Emilia Romagna')
      create(:province, description: 'Forlí-Cesena', region: region)
      get interest_borders_path, params: { q: 'Forlì', format: :json }
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves municipalities correctly' do
      region = Region.find_by(description: 'Emilia Romagna')
      province = create(:province, description: 'Forlí-Cesena', region: region)
      create(:municipality, description: 'Forlimpopoli', province: province)
      get interest_borders_path, params: { q: 'forlì', format: :json }
      expect(assigns(:results).count).to eq 2
    end
  end
end
