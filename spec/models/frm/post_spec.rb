require 'spec_helper'

describe Frm::Post do
  context 'when created' do

    before(:each) do
      #load_database
    end

    context 'page calculation' do
      let(:topic) {create(:frm_topic)}
      context 'when is the first post' do
        let(:post) { create(:post, topic: topic) }
        it 'has 1 as page' do
          expect(post.page).to eq 1
        end
      end

      context "when is the #{TOPICS_PER_PAGE} post" do
        let(:posts) {create_list(:post, TOPICS_PER_PAGE, topic: topic)}
        it 'has 1 as page' do
          expect(posts.last.page).to eq 1
        end
      end

      context "when is the #{TOPICS_PER_PAGE+1} post" do
        let(:posts) {create_list(:post, TOPICS_PER_PAGE+1, topic: topic)}
        it 'has 2 as page' do
          expect(posts.last.page).to eq 2
        end
      end

      context "when is the #{TOPICS_PER_PAGE*2} post" do
        let(:posts) {create_list(:post, TOPICS_PER_PAGE*2, topic: topic)}
        it 'has 2 as page' do
          expect(posts.last.page).to eq 2
        end
      end

      context "when is the #{TOPICS_PER_PAGE*2 + 1} post" do
        let(:posts) {create_list(:post, TOPICS_PER_PAGE*2 + 1, topic: topic)}
        it 'has 3 as page' do
          expect(posts.last.page).to eq 3
        end
      end
    end
  end
end
