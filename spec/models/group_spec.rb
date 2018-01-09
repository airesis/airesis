require 'rails_helper'
require 'paperclip/matchers'

describe Group do
  let(:group) { build(:group) }

  context 'validations' do
    include Paperclip::Shoulda::Matchers
    it { should validate_attachment_size(:image).less_than(UPLOAD_LIMIT_IMAGES.bytes) }
  end

  context 'when created' do
    before(:each) do
      load_database
      group.save
    end

    it "has #{UPLOAD_LIMIT_GROUPS / 1024}KB available as space" do
      expect(group.max_storage_size).to eq UPLOAD_LIMIT_GROUPS / 1024
    end

    it 'has one participant' do
      group.reload
      expect(group.group_participations_count).to eq 1
    end

    it 'has a slug' do
      expect(group.slug).to eq to_slug_format(group.name)
    end

    context 'when title changes' do
      let(:new_name) { Faker::Company.name }
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

  describe '#look' do
    let(:municipality) { create(:municipality) }
    let(:province) { municipality.province }
    let(:groups) { [create(:group, num_participants: 1, name: 'hello group title'),
                    create(:group, num_participants: 2, description: 'group hello description'),
                    create(:group, num_participants: 2, tags_list: 'hello'),
                    create(:group, num_participants: 3, description: 'hello'),
                    create(:group, num_participants: 2, tags_list: 'hello,world', interest_border_tkn: InterestBorder.to_key(municipality)),
                    create(:group, num_participants: 5, tags_list: 'ciao,hello', interest_border_tkn: InterestBorder.to_key(province))] }

    before do
      load_database
      groups
    end

    context 'method is called with tag parameter' do
      it 'returns all groups with that tag associated ordered by participants an date of creation' do
        expect(described_class.look(tag: 'hello')).to eq [groups[5], groups[4], groups[2]]
      end
    end

    context 'search by text' do
      it 'returns all groups that match the word' do
        expect(described_class.look(search: 'hello')).to eq [groups[0], groups[3], groups[1]]
      end

      it 'returns all groups that match all the words' do
        expect(described_class.look(search: 'hello group')).to eq [groups[0], groups[1]]
      end

      it 'returns all groups that match any of the words' do
        expect(described_class.look(search: 'title description', and: false)).to eq [groups[0], groups[1]]
      end
    end

    context 'search by interest border' do
      it 'can search within an area' do
        expect(described_class.look(interest_border: InterestBorder.to_key(province), area: true)).to eq [groups[5], groups[4]]
      end

      it 'can search a specific place' do
        expect(described_class.look(interest_border: InterestBorder.to_key(province))).to eq [groups[5]]
      end

    end
  end

  describe '#most_active' do
    it 'returns a list of the 5 most active groups' do

    end
  end

  describe 'interest border field' do
    before do
      load_database
    end

    it 'populates the attributes properly' do
      continent = Continent.first
      country = Country.first
      region = Region.first
      province = Province.first
      municipality = Municipality.first
      municipality2 = Municipality.create(description: 'Marzabotto',
                                          province: province,
                                          region: region,
                                          country: country,
                                          continent: continent,
                                          population: 34)

      group = create(:group, interest_border_tkn: "C-#{municipality.id}")

      expect(group.interest_border_token).to eq "C-#{municipality.id}"
      expect(group.derived_interest_borders_tokens).to match_array ["K-#{continent.id}",
                                                                    "S-#{country.id}",
                                                                    "R-#{region.id}",
                                                                    "P-#{province.id}",
                                                                    "C-#{municipality.id}"]
    end
  end
end
