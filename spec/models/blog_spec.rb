require 'rails_helper'

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
      blog = build(:blog, title: 'hello' * 100)
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

  context 'when created' do
    let(:user) { create(:user) }
    let(:blog) { create(:blog, user: user) }

    it 'has a slug' do
      expect(blog.slug).to eq to_slug_format(blog.title)
    end

    context 'when title changes' do
      let(:new_title) { Faker::Company.name }
      before(:each) do
        blog.update(title: new_title)
      end

      it 'updates the slug' do
        expect(blog.slug).to eq to_slug_format(new_title)
      end

      it 'keeps the old slug' do
        expect(blog.slugs.count).to eq 2
      end
    end

    context 'retrieves territories correctly' do
      let(:sys_locale) { create(:sys_locale, territory: territory) }

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

    describe '#look' do
      # let(:municipality) { create(:municipality) }
      # let(:province) { municipality.province }
      let(:blogs) { [create(:blog, title: 'hello group title'),
                      create(:blog, title: 'Miriam'),
                      create(:blog, title: 'My blog'),
                      create(:blog, title: 'Astonishing news')] }

      before do
        load_database
        blogs
        create(:blog_post, blog: blogs[1], tags_list: 'hello')
        create(:blog_post, blog: blogs[2], tags_list: 'hello,world')
        create(:blog_post, blog: blogs[3], tags_list: 'ciao,hello')
      end

      context 'method is called with tag parameter' do
        it 'returns all blogs with posts with that tag associated ordered by last ones created' do
          expect(described_class.look(tag: 'hello')).to eq [blogs[3], blogs[2], blogs[1]]
        end
      end

      context 'search by text' do
        it 'returns all blogs that match the word' do
          expect(described_class.look(search: 'hello')).to eq [blogs[0]]
        end

        it 'returns all blogs that match all the words' do
          expect(described_class.look(search: 'hello group')).to eq [blogs[0]]
        end

        it 'returns all blogs that match any of the words' do
          expect(described_class.look(search: 'hello Miriam', and: false)).to eq [blogs[1], blogs[0]]
        end
      end
    end
  end
end
