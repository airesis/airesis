require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe 'create proposal solutions', type: :feature, js: true do

  it 'creates solutions in his public proposal' do
    @user = create(:user)
    @ability = Ability.new(@user)
    @public_proposal = create(:public_proposal, current_user_id: @user.id)

    login_as @user, scope: :user

    visit edit_proposal_path(@public_proposal)
    page_should_be_ok
    expect(page).to have_content @public_proposal.title
    expect(@ability).to be_able_to(:show, @public_proposal)
    expect(@ability).to be_able_to(:participate, @public_proposal)

    click_link I18n.t('pages.proposals.edit.add_solution.standard')
    expect(page).to have_content "Solution 2"

  end

end
