require 'rails_helper'

RSpec.describe User do
  it 'populates the attributes properly' do
    municipality = create(:municipality, :bologna)
    province = municipality.province
    region = province.region
    country = region.country
    continent = country.continent

    user = create(:user, interest_borders_tokens: InterestBorder.to_key(municipality))

    expect(user.interest_borders.count).to eq 1
    expect(user.derived_interest_borders_tokens).to match_array ["K-#{continent.id}",
                                                                 "S-#{country.id}",
                                                                 "R-#{region.id}",
                                                                 "P-#{province.id}",
                                                                 "C-#{municipality.id}"]
  end

  describe '#by_interest_borders' do
    it 'can be searched by interest border' do
      municipality = create(:municipality, :bologna)
      province = municipality.province
      user = create(:user, interest_borders_tokens: InterestBorder.to_key(municipality))
      expect(described_class.by_interest_borders([InterestBorder.to_key(province)])).to include user
    end
  end

  describe 'when created' do
    it 'has some alerts blocked by default' do
      user = create(:user)
      expect(user.reload.blocked_alerts.count).to be >= 0
    end
  end
end
