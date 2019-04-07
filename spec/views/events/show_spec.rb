require 'rails_helper'

RSpec.describe 'events/show.html.erb' do
  include Devise::Test::ControllerHelpers

  context 'votation event' do
    let(:event) { create(:vote_event) }

    before do
      proposals = create_list(:in_vote_public_proposal, 3)
      proposals.each do |proposal|
        proposal.update_columns(vote_period_id: event.id)
      end
      assign(:event, event)
      assign(:proposals, event.proposals.for_list)
    end

    it 'displays the page correctly' do
      render
      expect(rendered).to include event.title
    end
  end
end
