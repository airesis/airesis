require 'rails_helper'

RSpec.describe 'users/show.html.erb' do
  include Devise::Test::ControllerHelpers

  context 'with group participations' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      create_participation(user, group)
      assign(:user, user)
      allow(view).to receive(:current_user).and_return(user)
    end

    it 'displays the page correctly' do
      render
      expect(rendered).to safe_include(I18n.t('pages.users.show.profile_info'))
    end
  end
end
