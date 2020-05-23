require 'rails_helper'

RSpec.describe Frm::Forum do
  describe 'validations' do
    subject { build(:frm_forum) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(1.megabyte) }
  end

  context 'when created' do
    let(:forum) { create(:frm_forum) }

    before do
      load_database
    end

    it 'has a slug' do
      expect(forum.slug).to eq to_slug_format(forum.name)
    end

    context 'when name changes' do
      let(:new_name) { Faker::Company.name }

      before do
        forum.update(name: new_name)
      end

      it 'updates the slug' do
        expect(forum.slug).to eq to_slug_format(new_name)
      end
    end
  end
end
