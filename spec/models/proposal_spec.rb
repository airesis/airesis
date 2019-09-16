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

  describe '#destroy' do
    context 'when is public' do
      before do
        load_database
        public_proposal
      end

      it 'can be destroyed' do
        expect(public_proposal.destroy).to be_truthy
      end
    end

    context 'when is private' do
      let(:proposal) { create(:group_proposal) }

      it 'decreases the counter cache of the tags' do
        tag = proposal.tags.first
        expect { proposal.destroy }.to change { tag.reload.tag_counters.first.proposals_count }.from(1).to(0)
      end
    end
  end

  describe 'interest borders and derived interest borders' do
    let(:municipality) { Municipality.first }
    let(:province) { municipality.province }
    let(:region) { province.region }
    let(:country) { region.country }
    let(:continent) { country.continent }

    it 'populates the attributes properly' do
      municipality2 = create(:municipality, description: 'Marzabotto', province: province)
      proposal = create(:proposal,
                        interest_borders_tkn: "#{InterestBorder.to_key(municipality)},C-45897,#{InterestBorder.to_key(municipality2)}")

      expect(proposal.interest_borders_tokens).to eq [InterestBorder.to_key(municipality),
                                                      InterestBorder.to_key(municipality2)]
      expect(proposal.derived_interest_borders_tokens).to match_array [InterestBorder.to_key(continent),
                                                                       InterestBorder.to_key(country),
                                                                       InterestBorder.to_key(region),
                                                                       InterestBorder.to_key(province),
                                                                       InterestBorder.to_key(municipality),
                                                                       InterestBorder.to_key(municipality2)]
    end

    it 'can be searched by interest border' do
      proposal = create(:proposal, interest_borders_tkn: InterestBorder.to_key(municipality))
      expect(described_class.by_interest_borders([InterestBorder.to_key(province)])).to include proposal
    end

    it 'increases the counter cache of the tag for the country and the continent' do
      proposal = create(:proposal, interest_borders_tkn: InterestBorder.to_key(municipality))
      tag = proposal.tags.first
      expect(tag.tag_counters.length).to eq(1)
      expect(tag.tag_counters.first.proposals_count).to eq(1)
    end
  end
end
