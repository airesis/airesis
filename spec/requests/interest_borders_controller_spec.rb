require 'rails_helper'

RSpec.describe InterestBordersController, :aggregate_failures do
  let(:json) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET index' do
    let(:json_response) { JSON.parse(response.body) }

    it 'retrieves continents correctly' do
      continent = create(:continent, :europe)
      get interest_borders_path, params: { q: 'Eur', format: :json }
      expect(json_response.length).to eq 1
      expect(json).to match(a_hash_including(id: "K-#{continent.id}", text: include('Europe')))
    end

    it 'retrieves countries correctly' do
      country = create(:country, :italy)
      get interest_borders_path, params: { q: 'Ita', format: :json }
      expect(json_response.length).to eq 1
      expect(json).to match(a_hash_including(id: "S-#{country.id}", text: include('Italy')))
    end

    it 'retrieves regions correctly' do
      region = create(:region, :emilia_romagna)
      get interest_borders_path, params: { q: 'emi', format: :json }
      expect(json_response.length).to eq 1
      expect(json).to match(a_hash_including(id: "R-#{region.id}", text: include('Emilia')))
    end

    it 'retrieves provinces correctly' do
      region = create(:region, :emilia_romagna)
      create(:province, description: 'Forlí-Cesena', region: region)
      get interest_borders_path, params: { q: 'Forlì', format: :json }
      expect(json_response.length).to eq 1
      expect(json).to match([a_hash_including(:id, text: include('Forlí'))])
    end

    it 'retrieves municipalities correctly' do
      region = create(:region, :emilia_romagna)
      province = create(:province, description: 'Forlí-Cesena', region: region)
      create(:municipality, description: 'Forlimpopoli', province: province)
      get interest_borders_path, params: { q: 'forlì', format: :json }
      expect(json_response.length).to eq 2
      expect(json).to match([a_hash_including(:id, text: include('Forlí')),
                             a_hash_including(:id, text: include('Forlimpopoli'))])
    end
  end
end
