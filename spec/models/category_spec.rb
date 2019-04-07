require 'rails_helper'

describe Frm::Category do
  context 'when created' do
    let(:category) { create(:frm_category) }

    before do
      load_database
    end

    it 'has a slug' do
      expect(category.slug).to eq to_slug_format(category.name)
    end

    context 'when name changes' do
      let(:new_name) { Faker::Company.name }

      before do
        category.update(name: new_name)
      end

      it 'updates the slug' do
        expect(category.slug).to eq to_slug_format(new_name)
      end
    end
  end
end
