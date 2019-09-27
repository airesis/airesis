require 'rails_helper'

RSpec.describe Search do
  let(:user) { create(:user) }
  let(:groups) do
    [create(:group, name: 'what a group'),
     create(:group, name: 'hello'),
     create(:group, description: 'hello group')]
  end
  let(:proposals) do
    [create(:proposal, title: 'what a proposal'),
     create(:proposal, title: 'hello'),
     create(:proposal, content: 'hello proposal')]
  end
  let(:blogs) do
    [create(:blog, title: 'hello everyone'),
     create(:blog, title: 'hello'),
     create(:blog, title: 'my new blog')]
  end

  before do
    load_database
    groups
    proposals
    blogs
  end

  describe '#find' do
    it 'returns all matching groups, proposals and blogs' do
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
