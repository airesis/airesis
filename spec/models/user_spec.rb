require 'rails_helper'

describe User do

  before do
    load_database
  end

  it 'populates the attributes properly' do
    continent = Continent.first
    country = Country.first
    region = Region.first
    province = Province.first
    municipality = Municipality.first

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
      province = Province.first
      municipality = Municipality.first
      user = create(:user, interest_borders_tokens: InterestBorder.to_key(municipality))
      expect(User.by_interest_borders([InterestBorder.to_key(province)])).to include user
    end
  end
end
