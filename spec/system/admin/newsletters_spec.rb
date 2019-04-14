require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'the management of the newsletters' do
  let!(:admin) { create(:admin) }
  let(:newsletters) { create_list(:newsletter, 5) }
  let(:newsletter) { create(:newsletter) }

  before do
    login_as admin, scope: :user
  end

  after do
    logout :user
  end

  it 'can list newsletters' do
    newsletters
    visit admin_newsletters_path
    newsletters.each do |newsletter|
      expect(page).to have_content(newsletter.subject)
    end
  end
end
