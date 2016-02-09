require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe 'admin/certifications', type: :feature, js: true do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:groups) { create_list(:group, 3, current_user_id: user.id) }

  before :each do
    load_database
    login_as admin, scope: :user
  end

  after :each do
    logout :user
  end

  it 'can list certifications' do
    visit admin_certifications_path
    expect(page).to have_content(I18n.t('pages.certifications.index.title'))
  end
end
