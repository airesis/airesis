require 'spec_helper'

describe Group do
  let(:group) { build(:group, current_user_id: create(:user).id) }

  context 'when created' do
    before(:each) do
      load_database
      group.save
    end
    it 'has one participant' do
      group.reload
      expect(group.group_participations_count).to eq 1
    end
  end
end
