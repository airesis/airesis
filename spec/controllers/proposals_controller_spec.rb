require 'spec_helper'

describe ProposalsController, :type => :controller, search: :true do

  describe "GET index" do
    it "assigns @proposals" do
      user = create(:default_user)
      proposal = create(:public_proposal, quorum: BestQuorum.public.first, current_user_id: user.id)
      sleep 5
      get :tab_list
      expect(assigns(:proposals)).to eq([proposal])
    end

    it "renders the index template" do
      get :index, format: :html
      expect(response).to render_template(:index)
    end
  end
end