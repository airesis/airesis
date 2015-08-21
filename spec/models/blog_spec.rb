require 'spec_helper'

describe Blog do
  context 'title validation' do
    it 'must be present' do
      blog = build(:blog, title: nil)
      expect_errors_on_model_field(blog, :title, 1)
    end

    it 'must be at least one character' do
      blog = build(:blog, title: '')
      expect_errors_on_model_field(blog, :title, 1)
    end

    it 'must be maximum 100 character' do
      blog = build(:blog, title: 'hello'*100)
      expect_errors_on_model_field(blog, :title, 1)
    end
  end

  context 'user validation' do
    it 'must be present' do
      blog = build(:blog, user: nil)
      expect_errors_on_model_field(blog, :user, 1)
    end
  end

  it 'retrieves last post correctly' do
    blog = create(:blog)
    posts = create_list(:blog_post, 3, blog: blog)
    expect(blog.last_post).to eq BlogPost.last
  end

  context 'retrieves territoriers correctly' do
    let(:sys_locale) { create(:sys_locale, territory: territory) }
    let(:user) { create(:user) }
    let(:blog) { create(:blog, user: user) }

    context 'when user has a country attached as original locale' do
      let(:territory) { create(:country) }

      before(:each) do
        user.update(original_locale: sys_locale)
      end

      it 'retrieves it' do
        expect(blog.solr_country_id).to eq territory.id
      end

      it 'retrieves the continent as well' do
        expect(blog.solr_continent_id).to eq territory.continent_id
      end
    end
    context 'when user has a continent attached as original locale' do
      let(:territory) { create(:continent) }

      before(:each) do
        user.update(original_locale: sys_locale)
      end

      it 'retrieves the continent' do
        expect(blog.solr_continent_id).to eq territory.id
      end

      it 'does not retrieve the country' do
        expect(blog.solr_country_id).to be_nil
      end
    end
  end
end
