require 'spec_helper'
require 'requests_helper'

describe "can list proposals and filter them", type: :feature, js: true, search: true do

  def search_and_check(text, list)
    within_left_menu do
      find(:css, '#search').set text
      click_link I18n.t('buttons.search')
    end
    within('.centerfloat') do
      expect(page).to have_content text
      list.select { |d| d.exclude? text }.each { |l| expect(page).to_not have_content l }
    end
  end

  it "can search by text" do
    user = create(:user)
    group = create(:group, current_user_id: user.id)
    ability = Ability.new(@user)
    titles = ['hello everybody', 'how are you', 'im a super proposal',
              'everyboday knows it', 'proposal good',
              'proposal bad', 'hello super', 'caccapupu', 'super super super', 'diamond knows']
    titles.each do |title|
      create(:group_proposal, title: title, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)])
    end
    proposals = Proposal.all
    expect(Proposal.count).to eq 10
    login_as user, scope: :user
    visit group_proposals_path(group)
    proposals.each { |proposal| expect(page).to have_content proposal.title }
    search_and_check('caccapupu', titles)
    search_and_check('how', titles)
    search_and_check('hello', titles)
    search_and_check('super', titles)
  end
end
