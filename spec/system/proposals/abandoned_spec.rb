require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'abandoned proposals', :js do
  before do
    load_database
  end

  context 'view it' do
    let!(:user) { create(:user) }
    let(:ability) { Ability.new(user) }
    let!(:proposal) { create(:public_proposal, current_user_id: user.id) }

    before do
      proposal.check_phase(true) # the proposal will be abandoned
      visit proposal_path(proposal)
    end

    it 'is shown correctly' do
      page_should_be_ok
      expect(page).to have_content proposal.title
    end
  end
end
