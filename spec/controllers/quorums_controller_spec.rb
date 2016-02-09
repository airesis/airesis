require 'spec_helper'
require 'requests_helper'

describe QuorumsController, type: :controller do
  let!(:province) { create(:province) }
  let!(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:quorum_params) do
    {
      group_id: group.id,
      best_quorum: {
        name: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        percentage: 0,
        valutations: 0,
        days_m: 1,
        hours_m: 0,
        minutes_m: 0,
        good_score: 50,
        vote_percentage: 0,
        vote_good_score: 50
      }
    }
  end
  describe 'POST create' do
    before(:each) do
      sign_in user
    end

    it 'responds to js' do
      post :create, quorum_params.merge(format: :js)
      expect(response).to have_http_status 200
    end

    it 'responds to html' do
      post :create, quorum_params
      expect(response).to have_http_status 302
    end
  end
end
