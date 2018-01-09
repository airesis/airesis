require 'rails_helper'

describe Search do
  let(:user) { create(:user) }
  let(:groups) { [create(:group, name: 'what a group'),
                  create(:group, name: 'hello'),
                  create(:group, description: 'hello group')] }
  let(:proposals) { [create(:proposal, title: 'what a proposal'),
                     create(:proposal, title: 'hello'),
                     create(:proposal, content: 'hello proposal')] }
  let(:blogs) { [create(:blog, title: 'hello everyone'),
                 create(:blog, title: 'hello'),
                 create(:blog, title: 'my new blog')] }

  before do
    load_database
    groups
    proposals
    blogs
  end

  describe '#find' do
    it 'returns all matching groups, proposals and blogs', :aggregate_failures do
      # boosts groups where user is admin
      # boosts groups where user is participant
      # boosts proposals I own
      # boosts proposals I participate in
      # boosts proposals in my groups
      search = described_class.new(user_id: user.id, q: 'hello')
      search.find

      expect(search.groups).to eq [groups[1], groups[2]]
      expect(search.proposals).to eq [proposals[1], proposals[2]]
      expect(search.blogs).to eq [blogs[1], blogs[0]]
    end
  end
end
