require 'spec_helper'

describe Frm::Topic do
  context 'when created' do
    let(:topic) { create(:frm_topic) }

    before(:each) do
      load_database
    end

    it 'has a slug' do
      expect(topic.slug).to eq to_slug_format(topic.subject)
    end

    context 'when subject changes' do
      let(:new_name) {Faker::Company.name}
      before(:each) do
        topic.update(subject: new_name)
      end

      it 'updates the slug' do
        expect(topic.slug).to eq to_slug_format(new_name)
      end
    end
  end
end
