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

    it 'has a slug' do
      expect(group.slug).to eq to_slug_format(group.name)
    end

    context 'when title changes' do
      let(:new_name) {Faker::Company.name}
      before(:each) do
        group.update(name: new_name)
      end

      it 'updates the slug' do
        expect(group.slug).to eq to_slug_format(new_name)
      end

      it 'keeps the old slug' do
        expect(group.slugs.count).to eq 2
      end
    end
  end
end
