require 'rails_helper'

describe InterestBordersController, type: :controller do
  describe 'GET index' do
    it 'retrieves continents correctly' do
      get :index, q: 'Eur', format: :json
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves countries correctly' do
      create(:country, description: 'Italy', continent: Continent.first)
      get :index, q: 'Ita', format: :json
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves regions correctly' do
      country = create(:country, description: 'Italy', continent: Continent.first)
      create(:region, description: 'Emilia-Romagna', country: country)
      get :index, q: 'emi', format: :json
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves provinces correctly' do
      country = create(:country, description: 'Italy', continent: Continent.first)
      region = create(:region, description: 'Emilia-Romagna', country: country)
      create(:province, description: 'Forlí-Cesena', region: region)
      get :index, q: 'Forlì', format: :json
      expect(assigns(:results).count).to eq 1
    end

    it 'retrieves municipalities correctly' do
      country = create(:country, description: 'Italy', continent: Continent.first)
      region = create(:region, description: 'Emilia-Romagna', country: country)
      province = create(:province, description: 'Forlí-Cesena', region: region)
      create(:municipality, description: 'Forlimpopoli', province: province)
      get :index, q: 'forlì', format: :json
      expect(assigns(:results).count).to eq 2
    end
  end
end
