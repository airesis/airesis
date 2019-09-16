require 'rails_helper'

describe Proposal, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:group_area) { create(:group_area, group: group) }
  let(:quorum) { create(:best_quorum, group_quorum: GroupQuorum.new(group: group)) } # min participants is 10% and good score is 50%. vote quorum 0, 50%+1
  let(:group_proposal) do
    create(:group_proposal,
           quorum: quorum,
           current_user_id: user.id,
           groups: [group],
           votation: { choise: 'new', start: 10.days.from_now, end: 14.days.from_now })
  end
  let(:group_area_proposal) do
    create(:group_proposal,
           quorum: quorum,
           current_user_id: user.id,
           groups: [group],
           group_area_id: group_area.id,
           votation: { choise: 'new', start: 10.days.from_now, end: 14.days.from_now })
  end
  let(:public_proposal) { create(:proposal, current_user_id: user.id) }

  context 'group proposal' do
    before do
      load_municipalities
      group_proposal
    end

    it 'can be destroyed' do
      expect(group_proposal.destroy).to be_truthy
    end

    it 'is private' do
      expect(group_proposal.private).to be_truthy
    end

    it 'is not area_private' do
      expect(group_proposal.area_private).to be_falsey
    end
  end

  context 'group area proposal' do
    before do
      load_municipalities
      group_area_proposal
    end

    it 'can be destroyed' do
      expect(group_area_proposal.destroy).to be_truthy
    end

    it 'is private' do
      expect(group_area_proposal.private).to be_truthy
    end

    it 'is area_private' do
      expect(group_area_proposal.area_private).to be_truthy
    end
  end

  context 'public proposal' do
    before do
      load_database
      public_proposal
    end

    it 'can be destroyed when public' do
      expect(public_proposal.destroy).to be_truthy
    end
  end

  describe 'interest border fields' do
    it 'populates the attributes properly' do
      municipality = Municipality.first
      province = municipality.province
      municipality2 = create(:municipality, description: 'Marzabotto', province: province)
      region = province.region
      country = region.country
      continent = country.continent

      proposal = create(:proposal, interest_borders_tkn: "C-#{municipality.id},C-45897,C-#{municipality2.id}")

      expect(proposal.interest_borders_tokens).to eq ["C-#{municipality.id}", "C-#{municipality2.id}"]
      expect(proposal.derived_interest_borders_tokens).to match_array ["K-#{continent.id}",
                                                                       "S-#{country.id}",
                                                                       "R-#{region.id}",
                                                                       "P-#{province.id}",
                                                                       "C-#{municipality.id}",
                                                                       "C-#{municipality2.id}"]
    end

    it 'can be searched by interest border' do
      province = Province.first
      municipality = Municipality.first
      proposal = create(:proposal, interest_borders_tkn: "C-#{municipality.id}")
      expect(described_class.by_interest_borders([InterestBorder.to_key(province)])).to include proposal
    end
  end
end
