require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe 'create proposal comments', type: :feature, js: true do
  before(:each) do
    load_database
  end

  it 'creates comments if not logged in' do
    @luser = create(:user)
    @user = create(:user)
    @ability = Ability.new(@user)
    @public_proposal = create(:public_proposal, current_user_id: @user.id)

    visit proposal_path(@public_proposal)
    page_should_be_ok
    expect(page).to have_content @public_proposal.title

    comment = Faker::Lorem.sentence
    within('#proposalNewComment') do
      fill_in I18n.t('pages.proposals.show.add_contribute'), with: comment
      click_button I18n.t('pages.proposals.show.send_contribute_button')
    end

    expect(page).to have_selector('form#new_user')
    within('form#new_user') do
      fill_in 'user_login', :with => @luser.email
      fill_in 'user_password', :with => 'topolino'
      click_button 'Login'
    end
    expect(page).to have_content(comment)
  end


  it 'creates comments in his public proposal' do
    @user = create(:user)
    @ability = Ability.new(@user)
    @public_proposal = create(:public_proposal, current_user_id: @user.id)

    login_as @user, scope: :user

    visit proposal_path(@public_proposal)
    page_should_be_ok
    expect(page).to have_content @public_proposal.title
    expect(@ability).to be_able_to(:show, @public_proposal)
    expect(@ability).to be_able_to(:participate, @public_proposal)

    comment = Faker::Lorem.sentence
    within('#proposalNewComment') do
      fill_in I18n.t('pages.proposals.show.add_contribute'), with: comment
      click_button I18n.t('pages.proposals.show.send_contribute_button')
    end
    expect(page).to have_content comment

    visit proposal_path(@public_proposal)
    expect(page).to have_content comment

    #open side panels
    i = 0
    max = 3
    comments = []
    page.all(:css, '.contribute-button').each do |el|
      el.click
      within('.suggestion_right') do
        icomment = Faker::Lorem.sentence
        comments << icomment
        fill_in I18n.t('pages.proposals.show.add_contribute'), with: icomment
        click_button I18n.t('pages.proposals.show.send_contribute_button')
      end
      expect(page).to have_content comment
      i+=1
      break if i > max
    end

    visit proposal_path(@public_proposal)
    expect(page).to have_content comment
    i = 0
    page.all(:css, '.contribute-button').each do |el|
      el.click
      expect(page).to have_content comments[i]
      i+=1
      break if i > max
    end
  end

  it 'create comments in proposals inside his group' do
    @user = create(:user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
    @proposal = create(:group_proposal, current_user_id: @user.id, group_proposals: [GroupProposal.new(group: @group)])

    login_as @user, scope: :user

    visit group_proposal_path(@group,@proposal)
    page_should_be_ok
    expect(page).to have_content @proposal.title
    expect(@ability).to be_able_to(:show, @proposal)
    expect(@ability).to be_able_to(:participate, @proposal)

    comment = Faker::Lorem.sentence
    within('#proposalNewComment') do
      fill_in I18n.t('pages.proposals.show.add_contribute'), with: comment
      click_button I18n.t('pages.proposals.show.send_contribute_button')
    end
    expect(page).to have_content comment

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment

    #open side panels
    i = 0
    max = 3
    comments = []
    page.all(:css, '.contribute-button').each do |el|
      el.click
      section_id = el['data-section_id']
      sleep 1
      within(".suggestion_right[data-section_id=\"#{section_id}\"]") do
        icomment = Faker::Lorem.sentence
        comments << icomment
        find(:css,'.blogNewCommentField').set icomment
        click_button I18n.t('pages.proposals.show.send_contribute_button')
      end
      expect(page).to have_content comment
      i+=1
      break if i > max
    end

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment
    i = 0
    page.all(:css, '.contribute-button').each do |el|
      el.click
      expect(page).to have_content comments[i]
      i+=1
      break if i > max
    end
  end

  it 'create comments in proposals inside a group where has permissions to participate' do
    @user = create(:user)

    @user2 = create(:user)
    @group = create(:group, current_user_id: @user2.id)
    @proposal = create(:group_proposal, current_user_id: @user2.id, group_proposals: [GroupProposal.new(group: @group)])

    create_participation(@user,@group)

    login_as @user, scope: :user

    @ability = Ability.new(@user)

    visit group_proposal_path(@group,@proposal)
    page_should_be_ok
    expect(page).to have_content @proposal.title
    expect(@ability).to be_able_to(:show, @proposal)
    expect(@ability).to be_able_to(:participate, @proposal)

    comment = Faker::Lorem.sentence
    within('#proposalNewComment') do
      fill_in I18n.t('pages.proposals.show.add_contribute'), with: comment
      click_button I18n.t('pages.proposals.show.send_contribute_button')
    end
    expect(page).to have_content comment

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment

    #open side panels
    i = 0
    max = 3
    comments = []
    page.all(:css, '.contribute-button').each do |el|
      el.click
      within('.suggestion_right') do
        icomment = Faker::Lorem.sentence
        comments << icomment
        fill_in 'proposal_comment_content', with: icomment
        click_button I18n.t('pages.proposals.show.send_contribute_button')
      end
      expect(page).to have_content comment
      i+=1
      break if i > max
    end

    visit group_proposal_path(@group,@proposal)
    expect(page).to have_content comment
    i = 0
    page.all(:css, '.contribute-button').each do |el|
      el.click
      expect(page).to have_content comments[i]
      i+=1
      break if i > max
    end
  end
end
