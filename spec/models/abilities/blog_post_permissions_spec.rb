require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'permissions blog posts', type: :model, seeds: true do
  let(:admin) { create(:user) }
  let!(:group) { create(:group, current_user_id: admin.id) }

  context 'group admin' do
    it 'can remove posts from page' do
      expect(Ability.new(admin)).to be_able_to(:remove_post, group)
    end
  end
end
