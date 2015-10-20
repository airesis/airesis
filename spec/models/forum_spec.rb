require 'spec_helper'

describe Frm::Forum do
  context 'when created' do
    let(:forum) { create(:frm_forum) }

    before(:each) do
      load_database
    end

    it 'has a slug' do
      expect(forum.slug).to eq to_slug_format(forum.name)
    end

    context 'when name changes' do
      let(:new_name) {Faker::Company.name}
      before(:each) do
        forum.update(name: new_name)
      end

      it 'updates the slug' do
        expect(forum.slug).to eq to_slug_format(new_name)
      end
    end
  end
end
